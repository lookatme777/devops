#!/bin/bash
set -eu

apt install -y xorriso isolinux  # install required tools

path_iso='/var/lib/vz/template/iso/'
iso_file="$path_iso/ubuntu-24.04.4-live-server-amd64.iso"
iso_url='https://releases.ubuntu.com/24.04.4/ubuntu-24.04.4-live-server-amd64.iso'

mkdir -p "$path_iso"

echo "--Start download check"

# Проверяем, есть ли ISO локально
if [ -f "$iso_file" ]; then
    echo "--ISO already exists locally. Skipping download."
else
    echo "--ISO not found. Downloading..."
    if wget -c -P "$path_iso" "$iso_url" > "$path_iso/download.log" 2>> "$path_iso/error.txt"; then
        echo "--Download complete"
    else
        echo "--Download failed! Check $path_iso/error.txt"
        exit 1
    fi
fi