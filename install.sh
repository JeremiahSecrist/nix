#!/bin/sh
set -e
source "${1}"

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

Format_Disk(){
sgdisk --zap-all "${DISK}"
wait $!
sgdisk --clear \
         --new=1:0:+550MiB --typecode=1:ef00 \
         --new=2:0:+16GiB   --typecode=2:8200 \
         --new=3:0:0       --typecode=3:8300 \
           "${DISK}"
wait $!
sleep 2
#Partition the drive and create subvolumes
mkfs.fat -F 32 -n boot "${DISK}1"
mkswap -L swap "${DISK}2" 
mkfs.ext4 -L nixos "${DISK}3"


wait $!
sleep 2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
}

Install_Nix(){
    pushd /home/nixos/.dotfiles
    sudo nixos-install -I nixos-config=./system/${SYSTEM_NAME}/configuration.nix
    popd
}

## init phase
Format_Disk
lsblk
Confirm
Install_Nix
echo "fin!"