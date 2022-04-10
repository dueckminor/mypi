import requests
import xml.etree.ElementTree as ET

def get_external_ip() -> str:
    response = requests.post(
        url="http://fritz.box:49000/igdupnp/control/WANIPConn1",
        headers={
            'Content-Type':'Content-Type: text/xml; charset="utf-8"',
            'SoapAction': 'urn:schemas-upnp-org:service:WANIPConnection:1#GetExternalIPAddress',
        },
        data="""<?xml version='1.0' encoding='utf-8'?>
            <s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'
                xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'>
                <s:Body>
                <u:GetExternalIPAddress xmlns:u='urn:schemas-upnp-org:service:WANIPConnection:1' /> 
                </s:Body>
            </s:Envelope>""")

    tree = ET.ElementTree(ET.fromstring(response.text))

    for element in tree.iter("NewExternalIPAddress"):
        return element.text
