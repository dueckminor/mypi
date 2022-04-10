import requests
import xml.etree.ElementTree as ET
from requests.auth import HTTPDigestAuth

def get_myfritz(username:str, password:str) -> str:
    response = requests.post(
        url="http://fritz.box:49000/upnp/control/x_myfritz",
        headers={
            'Content-Type':'Content-Type: text/xml; charset="utf-8"',
            'SoapAction': 'urn:dslforum-org:service:X_AVM-DE_MyFritz:1#GetInfo',
        },
        auth=HTTPDigestAuth(username,password),
        data="""<?xml version="1.0" encoding="utf-8"?>
            <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
            <s:Body>
               <u:GetInfo xmlns:u="urn:dslforum-org:service:X_AVM-DE_MyFritz:1">
               </u:GetInfo>
            </s:Body>
            </s:Envelope>""")

    tree = ET.ElementTree(ET.fromstring(response.text))

    for element in tree.iter("NewDynDNSName"):
        return element.text
