import requests
import xml.etree.ElementTree as ET
from requests.auth import HTTPDigestAuth

class SoapRequest:
    def __init__(self, url:str, urn:str, fn:str):
        self.__url = url
        self.__urn = urn
        self.__fn = fn
        self.__auth = None
        self.__doc = ET.Element('s:Envelope',attrib={
            'xmlns:s': 'http://schemas.xmlsoap.org/soap/envelope/',
            's:encodingStyle': 'http://schemas.xmlsoap.org/soap/encoding/'
        })
        self.__body = ET.SubElement(self.__doc,'s:Body')
        self.__inner = ET.SubElement(self.__body,f'u:{fn}',attrib={
            'xmlns:u': f'urn:{urn}'
        })
        self.__tree = None

    def auth(self,username:str, password: str):
        self.__auth = HTTPDigestAuth(username,password)

    def post(self):
        xml = ET.tostring(self.__doc)
        response = requests.post(
            url=self.__url,
            headers={
                'Content-Type':'Content-Type: text/xml; charset="utf-8"',
                'SoapAction': f'urn:{self.__urn}#{self.__fn}',
            },
            auth=self.__auth,
            data=xml)

        doc = response.text
        if doc.__contains__('<!ENTITY'):
            raise ValueError('XML document contians "<!ENTITY"')
        
        self.__tree = ET.ElementTree(ET.fromstring(doc))

    def get_element(self, name:str) -> str:
        for element in self.__tree.iter(name):
            return element.text 
