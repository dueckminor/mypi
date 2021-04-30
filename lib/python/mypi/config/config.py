import yaml
import os

rootDir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))))
mypiYml = None

def GetConfig():
    global rootDir
    global mypiYml

    with open(rootDir+"/config/mypi.yml") as stream:
        try:
            mypiYml = yaml.safe_load(stream)
        except:
            return None
    return mypiYml['config']

def WriteIfChanged(fileName, content):
    if os.path.exists(fileName):
        with open(fileName,mode='r') as file:
            existingContent = file.read()
            if existingContent == content:
                return
    with open(fileName, mode='w') as file:
        file.write(content)

def WriteYamlEtc(name, content):
    WriteIfChanged(rootDir+"/etc/"+name,yaml.dump(content))

def ReadYamlEtc(name):
    fileName = rootDir+"/etc/"+name
    with open(fileName,mode='r') as file:
        return yaml.safe_load(file)
    return None

