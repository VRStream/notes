#!/usr/bin/env python3

# program to decrypt encrypted on-disk dmesg file

import os
import sys
import json
import base64
import traceback

try:
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    from cryptography.hazmat.backends import default_backend
except ImportError:
    sys.stderr.write("Install missing packages, pip3 install --user requests cryptography\n")
    traceback.print_exc()
    sys.exit(-1)

master_key = "050801030904070A0F070B020C01040F".decode("hex")

data = open(sys.argv[1], "rb").read()

backend = default_backend()
cipher = Cipher(algorithms.AES(master_key), modes.ECB(), backend=backend)
decryptor = cipher.decryptor()

plaintext = decryptor.update(data) + decryptor.finalize()
print(plaintext)
