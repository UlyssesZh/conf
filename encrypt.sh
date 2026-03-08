#!/usr/bin/env bash

read -s -p "Password: " password
echo
read -s -p "Confirm Password: " password_confirm
echo
if [ "$password" != "$password_confirm" ]; then
	echo "Passwords do not match."
	exit 1
fi
cat secrets.decrypted | openssl enc -aes-256-cbc -salt -pbkdf2 -pass "pass:$password" | base64 > secrets.encrypted
