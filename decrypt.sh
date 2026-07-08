#!/usr/bin/env bash

read -s -p "Password: " password
echo
base64 -d < secrets.encrypted | openssl enc -aes-256-cbc -pbkdf2 -d -pass "pass:$password" > secrets.decrypted
