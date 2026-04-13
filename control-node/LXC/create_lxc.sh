#!/bin/bash

path="/var/lib/vz/template/cache/debian-13-standard_13.1-2_amd64.tar.zst"
lxc_id=800
name_vm="jenkins-lxc"
cores=2
memory=2048
pass="rootpass"

pct create $lxc_id $path \
    --storage local-lvm \
    --rootfs local-lvm:8 \
    --hostname $name_vm \
    --cores $cores \
    --memory $memory \
    --net0 name=eth0,bridge=vmbr1,ip=dhcp \
    --password $pass \
    --start 1