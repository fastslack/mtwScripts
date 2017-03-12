#!/usr/bin/python3
#
# Extract certificates and keys from an OpenVPN config file (*.ovpn)
# The config file is rewritten to use the extracted certificates.
#
# Usage: >$ extract_ovpn_cert.py VPNCONFIG.ovpn
#

import os
import re
import sys

# open input ovpn config file
ovpn_file_path =  os.path.dirname(os.path.abspath(sys.argv[1]))
ovpn_file = open(sys.argv[1], 'r')
ovpn_config = ovpn_file.read()
ovpn_file.close()

# open output config file
ovpn_file = open(os.path.splitext(sys.argv[1])[0]+"_nocert.ovpn", 'w')

# prepare regex
regex_tls = re.compile("<tls-auth>(.*)</tls-auth>", re.IGNORECASE|re.DOTALL)
regex_ca = re.compile("<ca>(.*)</ca>", re.IGNORECASE|re.DOTALL)
regex_cert = re.compile("<cert>(.*)</cert>", re.IGNORECASE|re.DOTALL)
regex_key = re.compile("<key>(.*)</key>", re.IGNORECASE|re.DOTALL)

# extract keys
match_string = regex_tls.search(ovpn_config)
if match_string is not None:
    cert_file = open(os.path.join(ovpn_file_path, 'tls-auth.key'), 'w')
    cert_file.write(match_string.group(1))
    cert_file.close()
    ovpn_config = regex_tls.sub("",ovpn_config)
    # get key direction setting
    regex_tls = re.compile("key-direction ([01])", re.IGNORECASE)
    match_string = regex_tls.search(ovpn_config)
    if match_string is not None:
        key_direction = match_string.group(1)
    else:
        key_direction = ""
    ovpn_file.write("tls-auth tls-auth.key " + key_direction + "\n")

match_string = regex_ca.search(ovpn_config)
if match_string is not None:
    cert_file = open(os.path.join(ovpn_file_path, 'ca.crt'), 'w')
    cert_file.write(match_string.group(1))
    cert_file.close()
    ovpn_config = regex_ca.sub("",ovpn_config)
    ovpn_file.write("ca ca.crt\n")

match_string = regex_cert.search(ovpn_config)
if match_string is not None:
    cert_file = open(os.path.join(ovpn_file_path, 'client.crt'), 'w')
    cert_file.write(match_string.group(1))
    cert_file.close()
    ovpn_config = regex_cert.sub("",ovpn_config)
    ovpn_file.write("cert client.crt\n")

match_string = regex_key.search(ovpn_config)
if match_string is not None:
    cert_file = open(os.path.join(ovpn_file_path, 'client.key'), 'w')
    cert_file.write(match_string.group(1))
    cert_file.close()
    ovpn_config = regex_key.sub("",ovpn_config)
    ovpn_file.write("key client.key\n")

# copy and append previous config
ovpn_file.write(ovpn_config)
ovpn_file.close()
