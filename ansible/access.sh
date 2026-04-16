#!/bin/bash
set -eu

source ./bash.cfg

# Create user if not exist
pveum user list | grep -q $user || \
pveum user add ansible@pve --password $password

# ACL
pveum aclmod / -user ansible@pve -role Administrator
pveum aclmod /nodes/pve -user $user -role PVEAdmin

# Remove token if exists
pveum user token list $user | grep -q "$token" && \
pveum user token remove $user $token

# Create fresh token
pveum user token add $user $token --privsep 0 \ 
--output-format json > /root/credprox.json

echo "Credentials was create"
