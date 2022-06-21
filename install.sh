#!/bin/sh
set -e
source ./laptop.env

Confirm(){
    read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        break
        ;;
    *)
        exit 1
        ;;
esac

}
Await() {
    wait $!
    sleep 2
}
Format_Disk(){
sgdisk --zap-all "${DISK}"

Await

sgdisk --clear \
         --new=1:0:+550MiB --typecode=1:ef00 \
         --new=2:0:+16GiB   --typecode=2:8200 \
         --new=3:0:0       --typecode=3:8300 \
           "${DISK}"

#Partition the drive and create subvolumes
mkfs.fat -F 32 -n boot "${DISK}1"
mkswap -L swap "${DISK}2" 
mkfs.ext4 -L nixos "${DISK}3"

Await

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt
}

Encrypted_Format_Disk(){
    # Clear Disk
    sgdisk --zap-all "${DISK}"
    Await

    # Create Partitions
    sgdisk --clear \
         --new=1:0:+550MiB  --typecode=1:ef00
         --new=2:0:0        --typecode=2:8300
    cryptsetup luksFormat   ${DISK}2
    cryptsetup luksOpen     ${DISK}2 enc-pv
    lvcreate -L 8G -n swap vg
    lvcreate -l '100%FREE' -n nixos vg

    # Format Partitions
    mkfs.fat    -F 32 -n boot ${DISK}1
    mkfs.ext4   -L nixos /dev/vg/root
    mkswap      -L swap /dev/vg/swap

    # Mount Partitions
    mount   /dev/disk/by-label/nixos /mnt
    mkdir   -p /mnt/boot
    mount   /dev/disk/by-label/boot /mnt/boot
    swapon  /dev/disk/by-label/swap
    
}
Install_Nix() {
    nix-install --flake https://github.com/arouzing/nix#${SYSTEM_NAME} --root /mnt
}

## init phase
Encrypted_Format_Disk
lsblk
Confirm
Install_Nix
echo "fin!"