import docker

__client = None

def get_client():
    global __client
    if __client is None:
        __client = docker.from_env()
    return __client

def Run():
    client = get_client()
    print(client.containers.get("mypi-router").status)

def Status(name):
    client = get_client()
    container = client.containers.get(name)
    if container is None:
        return None
    return container.status
