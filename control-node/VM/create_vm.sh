#!/bin/bash
set -eu                  # error - stop script

# ---------------------------
# Param VM
# ---------------------------
vmid=777
name="ControlNode"
memory=4096
sockets=1
cores=2
scsihw="virtio-scsi-pci"
net="virtio,bridge=vmbr0"
disk_size="20"
efidisk_size="512M"

# Path ISO
nocloud_iso="/var/lib/vz/template/iso/installer.iso"

cleanup() {
    echo "Error! Delete Machine VM $vmid..."
    qm destroy $vmid --purge || echo "VMID:$vmid is deleted"
    exit 1 
}

trap 'cleanup' ERR

# ---------------------------
# 1. Crate VM
# ---------------------------
qm create $vmid \
    --name $name \
    --memory $memory \
    --cores $cores \
    --sockets $sockets \
    --scsihw $scsihw \
    --net0 $net 

# ---------------------------
# 2. Main disk
# ---------------------------
qm set $vmid --scsi0 local-lvm:$disk_size

# ---------------------------
# 3. ISO disk
# ---------------------------
qm set $vmid --ide2 $nocloud_iso,media=cdrom

# ---------------------------
# 4. Boot order
# ---------------------------
qm set $vmid --boot 'order=ide2;scsi0'

# ---------------------------
# 5. Start VM
# ---------------------------
qm start $vmid
echo "VM $vmid is starting... waiting for autoinstall to complete."

# ---------------------------
# 6. Waiting poweroff VM
# ---------------------------
while [[ $(qm status $vmid) != "status: stopped" ]]; do
    echo "Waiting for VM to finish autoinstall..."
    sleep 10
done

# ---------------------------
# 7. Disable ISO + fix boot
# ---------------------------
qm set $vmid --cdrom none
qm set $vmid --delete ide2
qm set $vmid --boot 'order=scsi0;net0'

echo "ISO disconnected. Boot order set to disk."

# ---------------------------
# 8. Start installed system
# ---------------------------
qm start $vmid

echo "VM $vmid started from disk."