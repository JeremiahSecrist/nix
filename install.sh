#!/bin/sh
set -e
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
Select_Disk(){
    lsblk -f
    drives=$(lsblk -d | tail -n+2 | cut -d" " -f1 | tr '\n' ' ') 
    drives="quit ${drives}"
    echo "Please select a disk"
    select i in $drives; do
    if [ $i = "quit" ]; then
        echo "ABORT!"
        exit 1
    else
        echo "/dev/${i} selected"
        DSKSLC="${i}"
        break
    fi
    done
}
Format_Disk(){
sgdisk --zap-all /dev/${DSKSLC}
wait $!
sgdisk --clear \
         --new=1:0:+550MiB --typecode=1:ef00 \
         --new=2:0:+8GiB   --typecode=2:8200 \
         --new=3:0:0       --typecode=3:8300 \
           "/dev/${DSKSLC}"
wait $!
sleep 2
#Partition the drive and create subvolumes
mkfs.fat -F 32 -n boot "/dev/${DSKSLC}1"
mkswap -L swap "/dev/${DSKSLC}2" 
mkfs.ext4 -L nixos "/dev/${DSKSLC}3"


wait $!
sleep 2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
}

Install_Nix(){
    pushd ~/.dotfiles
    sudo nixos-install -I nixos-config=./system/configuration.nix
    popd
}

## init phase
Select_Disk
Confirm
Format_Disk
lsblk
Confirm
Install_Nix
echo "fin!"