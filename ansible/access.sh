#!/bin/bash

user="ansible@pve"
token="tokenansible"
file="/root/credprox.json"

# Create user if not exist
pveum user list | grep -q "ansible@pve" || \
pveum user add ansible@pve --password secret123

# ACL
pveum aclmod / -user ansible@pve -role Administrator
pveum aclmod /nodes/pve -user $user -role PVEAdmin

# Remove token if exists
pveum user token list $user | grep -q "$token" && \
pveum user token remove $user $token

# Create fresh token
pveum user token add $user $token --privsep 0 --output-format json > /root/credprox.json

echo "Credentials was create"
