import yaml
import os
import platform
from typing import Union,Optional
import re

rootDir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))))
mypiYml = None
__secrets_yml = None

def get_root_dir():
    return rootDir

def fn_root(*parts: str):
    return os.path.join(rootDir, *parts)
def fn_etc(*parts: str):
    return os.path.join(rootDir, 'etc', *parts)

def md(*parts: str):
    dir = os.path.join(rootDir, *parts)
    os.makedirs(dir,exist_ok=True)

__cpu = None
__goarch = None

def __get_cpu():
    global __cpu
    global __goarch
    if __cpu is not None:
        return
    processor = platform.processor()
    if processor is None or processor == "":
        processor = platform.machine()
    print(f'processor: {processor}')
    if processor == "aarch64":
        __cpu = "aarch64"
        __goarch = "arm64"

def get_cpu():
    global __cpu
    __get_cpu()
    return __cpu
def get_goarch():
    global __goarch
    __get_cpu()
    return __goarch

def GetConfig() -> Optional[dict]:
    global rootDir
    global mypiYml

    with open(rootDir+"/config/mypi.yml") as stream:
        try:
            mypiYml = yaml.safe_load(stream)
        except:
            return None
    return mypiYml['config']

def get_secrets() -> Optional[dict]:
    global rootDir
    global __secrets_yml

    with open(rootDir+"/config/secrets.yml") as stream:
        try:
            __secrets_yml = yaml.safe_load(stream)
        except:
            return None
    return __secrets_yml['config']


def get_service_dir(service_name:str) -> str:
    return os.path.join(rootDir,'services',service_name)

def WriteIfChanged(fileName, content: str):
    if os.path.exists(fileName):
        with open(fileName,mode='r') as file:
            existingContent = file.read()
            if existingContent == content:
                return
    with open(fileName, mode='w') as file:
        file.write(content)

def WriteConfigEtc(name, content):
    WriteIfChanged(rootDir+"/etc/"+name,content)

def WriteYamlEtc(name, content):
    WriteIfChanged(rootDir+"/etc/"+name,yaml.dump(content))

def ReadYamlEtc(name):
    fileName = rootDir+"/etc/"+name
    with open(fileName,mode='r') as file:
        return yaml.safe_load(file)
    return None

def ReadConfigEtc(name):
    fileName = rootDir+"/etc/"+name
    with open(fileName,mode='r') as file:
        return file.read()
    return None

def StripComments(content:str) -> str:
    result = ''
    for line in content.splitlines():
        if re.match('^[ \t]*#',line):
            continue
        if re.match('^[ \t]*$',line):
            continue
        result += line+'\n'
    return result
