import requests
import xml.etree.ElementTree as ET
from requests.auth import HTTPDigestAuth
from .soap import SoapRequest

def get_myfritz(username:str, password:str) -> str:
    r = SoapRequest(
        url='http://fritz.box:49000/upnp/control/x_myfritz',
        urn='dslforum-org:service:X_AVM-DE_MyFritz:1',
        fn='GetInfo')
    r.auth(username,password)
    r.post()
    return r.get_element('NewDynDNSName')
