
from webdav4.client import Client
from mypi.config import get_secrets

class Backup:
    def __init__(self, url:str, username:str,password:str):
        self.client = Client(url,auth=(username,password))

    @classmethod
    def from_env(cls) -> "Backup":
        secrets = get_secrets()
        return cls(
            url=secrets['webdav']['url'],
            username=secrets['webdav']['username'],
            password=secrets['webdav']['password'])
    