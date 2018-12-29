#!/usr/bin/env bash

# <service>
#     <serviceType>urn:dslforum-org:service:WANIPConnection:1</serviceType>
#     <serviceId>urn:WANIPConnection-com:serviceId:WANIPConnection1</serviceId>
#     <controlURL>/upnp/control/wanipconnection1</controlURL>
#     <eventSubURL>/upnp/control/wanipconnection1</eventSubURL>
#     <SCPDURL>/wanipconnSCPD.xml</SCPDURL>
# </service>

FritzBox::GetExternalIP() {
    curl "http://fritz.box:49000/igdupnp/control/WANIPConn1" \
        -H "Content-Type: text/xml; charset=\"utf-8\"" \
        -H "SoapAction:urn:schemas-upnp-org:service:WANIPConnection:1#GetExternalIPAddress" \
        -d "<?xml version='1.0' encoding='utf-8'?> 
                <s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' 
                    xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'> 
                  <s:Body>
                    <u:GetExternalIPAddress xmlns:u='urn:schemas-upnp-org:service:WANIPConnection:1' /> 
                  </s:Body>
                </s:Envelope>" -s |\
    grep -Eo '\<[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}\>'
}


# <service>
#     <serviceType>urn:dslforum-org:service:X_AVM-DE_MyFritz:1</serviceType>
#     <serviceId>
#         urn:X_AVM-DE_MyFritz-com:serviceId:X_AVM-DE_MyFritz1
#     </serviceId>
#     <controlURL>/upnp/control/x_myfritz</controlURL>
#     <eventSubURL>/upnp/control/x_myfritz</eventSubURL>
#     <SCPDURL>/x_myfritzSCPD.xml</SCPDURL>
# </service>

FritzBox::Login() {
    _FritzBox_USER="${1}"
    _FritzBox_PASSWORD="${2}"
}

FritzBox::GetMyFritz() {

    curl -4 -k -s --anyauth -u "${_FritzBox_USER}:${_FritzBox_PASSWORD}"       \
        "http://fritz.box:49000/upnp/control/x_myfritz"                        \
        -H 'Content-Type: text/xml; charset="utf-8"'                           \
        -H 'SoapAction: urn:dslforum-org:service:X_AVM-DE_MyFritz:1#GetInfo'   \
        -d '<?xml version="1.0" encoding="utf-8"?>
            <s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
            <s:Body>
               <u:GetInfo xmlns:u="urn:dslforum-org:service:X_AVM-DE_MyFritz:1">
               </u:GetInfo>
            </s:Body>
            </s:Envelope>'                                                     \
    | grep NewDynDNSName | sed 's/<.*>\(.*\)<.*>/\1/'
}