import yaml
import os
import platform
from typing import Union
import re

rootDir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))))
mypiYml = None

def get_root_dir():
    return rootDir

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

def GetConfig():
    global rootDir
    global mypiYml

    with open(rootDir+"/config/mypi.yml") as stream:
        try:
            mypiYml = yaml.safe_load(stream)
        except:
            return None
    return mypiYml['config']

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
