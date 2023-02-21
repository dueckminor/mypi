import os
import sys
import subprocess
from ..config import get_service_dir,get_root_dir
from ..docker import get_client
import docker
import yaml
from typing import Optional,List
from ..console.powerline import Powerline

class Service:
    def __init__(self, name:str):
        self.name = name
        self.dir = get_service_dir(name)
        
    def dump_action(self, action_name:str):
        with Powerline() as p:
            p.blue_segment(text=self.name)
            p.grey_segment(text=action_name)
        
    def call_action(self, action_name:str):
        self.dump_action(action_name)
        script = self._get_action(action_name)
        if script:
            cmd = subprocess.Popen(script)
            cmd.communicate()
        elif action_name == 'start':     self.start()
        elif action_name == 'stop':      self.stop()
        elif action_name == 'restart':   self.restart()
        elif action_name == 'recreate':  self.recreate()
        elif action_name == 'sh':        self.sh()
        else:
            print(f'found no action named {action_name}!')
                  
    def _get_action(self, action_name:str) -> Optional[str]:
        script = os.path.join(self.dir,'actions',action_name)
        if os.path.exists(script):
            return script
        return None
    
    def _get_container(self) -> docker.models.containers.Container:
        client = get_client()
        try:
            container = client.containers.get(self.name)
        except docker.errors.NotFound:
            return None
        return container

    def stop(self):
        container = self._get_container()
        if not container:
            return
        print(f'status: {container.status}')
        if container.status == 'running' or container.status == 'restarting':
            container.stop()

    def restart(self):
        self.call_action('stop')
        self.call_action('start')
        
    def recreate(self):
        self.call_action('stop')
        container = self._get_container()
        if container:
            container.remove()
        self.call_action('start')

    def sh(self):
        container = self._get_container()
        if container:
            rc = os.system(f'docker exec -it {self.name} ash')
            print()
            sys.exit(rc)

    def start(self):
        create_config = self._get_action("create-config")
        if create_config:
            self.dump_action("create-config")
            subprocess.Popen(create_config).communicate()

        pre_start = self._get_action("pre-start")
        if pre_start:
            self.dump_action("pre-start")
            subprocess.Popen(pre_start).communicate()
        
        with open(os.path.join(self.dir,"service.yml")) as stream:
            service_yml = yaml.safe_load(stream)['service']
        
        client = get_client()
        
        image = service_yml['image']
        if not '/' in image:
            image = f'dueckminor/aarch64-{image}'

        if service_yml.get('pull'):
            client.images.pull(image)

        container = self._get_container()
        if container:
            if container.status == 'running':
                return
            container.remove()
        
        
        command=service_yml.get('command')
        ports={}
        for port in service_yml.get('ports') or []:
            port_parts = port.split(':')
            if len(port_parts)==1:
                ports[port_parts[0]+"/tcp"]=port_parts[0]
            else:
                ports[port_parts[1]]=port_parts[0]
            
        environment=service_yml.get('env')
        privileged=service_yml.get('privileged')
        networks=self._get_networks(service_yml)
        devices=service_yml.get('devices')
        mounts=service_yml.get('mount')
        volumes = []
        for mount in mounts or []:
            if ':' in mount:
                if mount[0]!='/':
                   mount = get_root_dir()+'/'+mount
            else:
                local = get_root_dir()+'/'+mount
                if not os.path.exists(local):
                    os.mkdir(local)
                mount = local+":/"+mount
            volumes.append(mount)
            
        print(volumes)
    
        kwargs={}
        if command:
            kwargs['command']=command
        if ports:
            kwargs['ports']=ports
        if volumes:
            kwargs['volumes']=volumes
        if environment:
            kwargs['environment']=environment
        if devices:
            kwargs['devices']=devices
        if privileged:
            kwargs['privileged']=True
        kwargs['network']=networks[0]
        kwargs['restart_policy']={
            'Name': 'unless-stopped', 
            'MaximumRetryCount': 0
        }

        container = client.containers.create(
            image=image,
            name=self.name,
            hostname=self.name,
            
            **kwargs)
        container.start()

        if len(networks)>1:
            for network in networks[1:]:
                client.networks.get(network).connect(container)

        container.reload()
        #print(yaml.dump(container.attrs))


    def _get_networks(self, service_yml:dict) -> List[str]:
        networks = service_yml.get('networks')
        network = service_yml.get('network')
        if networks and network:
            raise(BaseException('You must not use network AND networks!'))
        if networks:
            return networks
        if network:
            return [network]
        return ['mypi-net']