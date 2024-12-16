import ipaddress
import json
import sys

def main(ip_range):
    # Input IP range is in format '<start-IP-address>-<end-IP-address>'
    # Example: '192.168.1.10-192.168.2.25'
    # The code below parses the input string to get first and last IP address from a range
    start_end_ips = list(map(ipaddress.IPv4Address, (ip_range.split('-'))))
    start_ip = int(start_end_ips[0])
    end_ip = int(start_end_ips[1])

    # With the help of ipaddress library, all the IP addresses from the range
    # being calculated and put in the list
    ip_list = [str(ipaddress.IPv4Address(ip)) for ip in range(start_ip, end_ip + 1)]

    # Terraform expect json output with key-value pairs.
    # Key here is index (starts from 0) and the value is IP address
    print(json.dumps(dict((i, ip_addr) for i, ip_addr in enumerate(ip_list))))

if __name__ == "__main__":
    inp = sys.stdin.read()
    input_json = json.loads(inp)
    main(ip_range=input_json.get('ip_range'))
