import docker
import mypi.config
import mypi.docker
import os
import subprocess
import re

BLACK = '\033[30m'
RED = '\033[31m'
GREEN = '\033[32m'
YELLOW = '\033[33m'
BLUE = '\033[34m'
MAGENTA = '\033[35m'
CYAN = '\033[36m'
WHITE = '\033[37m'
UNDERLINE = '\033[4m'
RESET = '\033[0m'

docker_owner='dueckminor'
alpine_version='3.15.4'

p_env_mypi_git_repo = re.compile(r"^\s*ENV\s+MYPI_GIT_REPO\s*=\s*(\S*)\s*$")

class Image:
    def __init__(self, image_name:str):
        self.image_name = image_name
        self.dir = os.path.join(mypi.config.get_root_dir(),"docker",image_name)
        self.full_image_name=f"{docker_owner}/{mypi.config.get_cpu()}-{image_name}"

    def exists(self) -> bool:
        try:
            mypi.docker.get_client().images.get(self.full_image_name)
        except docker.errors.ImageNotFound:
            return False
        return True

    def filter_dockerfile(self, file_in, file_out):
        for line in file_in:
            line = line.replace('@ALPINE@',f"alpine:{alpine_version}")
            line = line.replace('@CPU@',mypi.config.get_cpu())
            line = line.replace('@GOARCH@',mypi.config.get_goarch())
            line = line.replace('@OWNER@',docker_owner)
            m = p_env_mypi_git_repo.match(line)
            if m is not None:
                self.git_repo = m.group(1)
            file_out.write(line)

    def __call_prepare_hook(self, dir_docker):
        prepare_sh = os.path.join(dir_docker,"prepare.sh")
        if not os.path.exists(prepare_sh):
            return
        subprocess.run(cwd=dir_docker,args=[prepare_sh],check=True)

    def __choose_dir_docker_build(self, dir_docker):
        dir_docker_build = os.path.join(dir_docker,"src")
        if os.path.exists(os.path.join(dir_docker_build,"Dockerfile")):
            return dir_docker_build
        return dir_docker


    def build(self, only_if_missing=False, rebuild=False):
        print(f"{BLUE}Building {self.full_image_name} ... {RESET}")

        if only_if_missing and self.exists():
            return

        dir_docker = self.dir

        self.__call_prepare_hook(dir_docker)
        dir_docker_build = self.__choose_dir_docker_build(dir_docker)

        cpu = mypi.config.get_cpu()

        dir_docker_tmp = os.path.join(dir_docker_build,f".docker/{cpu}")
        if not os.path.exists(dir_docker_tmp):
            os.makedirs(dir_docker_tmp)

        dockerfile_src = os.path.join(dir_docker_build,'Dockerfile')
        dockerfile_dst = os.path.join(dir_docker_tmp,'Dockerfile')

        args=['docker', 'build', '.', '-f', dockerfile_dst, '-t', self.full_image_name]

        self.git_repo=None
        with open(dockerfile_src, 'r') as file :
            with open(dockerfile_dst, 'w') as file_out :
                self.filter_dockerfile(file,file_out)

        if self.git_repo is not None:
            proc = subprocess.run(args=['git','ls-remote', self.git_repo, 'HEAD'],capture_output=True,check=True)
            output = proc.stdout.decode("utf-8")
            print(output)
            commit_id = output.split()[0]
            args.append('--build-arg')
            args.append(f"MYPI_GIT_COMMIT_ID=${commit_id}")

        if rebuild:
            args.append('--no-cache')

        subprocess.run(cwd=dir_docker_build,args=args,check=True)
        #mypi.docker.get_client().images.build(path=self.dir, tag=self.full_image_name)

