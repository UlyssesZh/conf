#!/data/data/com.termux/files/usr/bin/python3

import ipaddress
import socket
import time
import traceback
import os

from zeroconf import ServiceInfo, Zeroconf

def get_real_lan_ips():
	ips = set()
	try:
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		s.connect(("8.8.8.8", 80))
		lan_ip = s.getsockname()[0]
		s.close()
		if not lan_ip.startswith("127."):
			ips.add(lan_ip)
	except Exception:
		traceback.print_exc()

	try:
		host_info = socket.getaddrinfo(socket.getfqdn(), None)
		for item in host_info:
			ip = item[4][0]
			if not ip.startswith("127.") and ip != "::1":
				ips.add(ip)
	except Exception:
		traceback.print_exc()

	return list(ips)

hostname_file = '/data/data/com.termux/files/home/.hostname'
if not os.path.exists(hostname_file):
	print(f'Please set hostname in {hostname_file}')
	exit()
with open(hostname_file) as f:
	hostname = f.read()
lan_ips = get_real_lan_ips()

if not lan_ips:
	print("No active LAN IP addresses found! Check your Wi-Fi/Network connection.")
else:
	packed_addrs = []
	for ip in lan_ips:
		try:
			ip_obj = ipaddress.ip_address(ip)
			family = (
				socket.AF_INET6
				if ip_obj.version == 6
				else socket.AF_INET
			)
			packed_addrs.append(socket.inet_pton(family, ip))
		except ValueError:
			pass

	print(f"Broadcasting {hostname}.local on valid LAN IPs: {lan_ips}")

	zeroconf = Zeroconf()
	service = ServiceInfo(
		"_http._tcp.local.",
		f"{hostname}._http._tcp.local.",
		addresses=packed_addrs,
		port=8080,
		server=f"{hostname}.local.",
	)

	zeroconf.register_service(service)

	try:
		while True:
			time.sleep(1)
	except KeyboardInterrupt:
		zeroconf.unregister_service(service)
		zeroconf.close()
