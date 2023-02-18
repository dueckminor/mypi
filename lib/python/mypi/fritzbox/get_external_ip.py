from .soap import SoapRequest
import socket


def get_external_ip() -> str:
    # https://mattscodecave.com/posts/using-python-and-upnp-to-forward-a-port.html
    # SSDP_ADDR = "239.255.255.250"
    # SSDP_PORT = 1900
    # SSDP_MX = 2
    # SSDP_ST = "urn:dslforum-org:service:X_AVM-DE_MyFritz:1"
    # SSDP_ST = "urn:schemas-upnp-org:service:WANIPConnection:1"

    # ssdpRequest = "M-SEARCH * HTTP/1.1\r\n" + \
    #                 "HOST: %s:%d\r\n" % (SSDP_ADDR, SSDP_PORT) + \
    #                 "MAN: \"ssdp:discover\"\r\n" + \
    #                 "MX: %d\r\n" % (SSDP_MX, ) + \
    #                 "ST: %s\r\n" % (SSDP_ST, ) + "\r\n\r\n"
    # print(ssdpRequest)
    # sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 32)
    # sock.sendto(bytes(ssdpRequest,'utf-8'), (SSDP_ADDR, SSDP_PORT))
    # resp = sock.recv(1000)
    #print(resp.decode('utf-8'))

    r = SoapRequest(
        url='http://fritz.box:49000/igdupnp/control/WANIPConn1',
        urn='schemas-upnp-org:service:WANIPConnection:1',
        fn='GetExternalIPAddress')
    r.post()
    return r.get_element('NewExternalIPAddress')
