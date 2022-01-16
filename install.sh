#!/usr/bin/sh

Sel-Disk(){
    lsblk -f
    drives = "${lsblk -d | tail -n+2 | cut -d" " -f1 | tr '\n' ' '}"
    select i in $drives do echo "/dev/${i} selected"; done
}

sgdisk --zap-all /dev/sda

sgdisk --clear \
         --new=1:0:+550MiB --typecode=1:ef00 \
         --new=2:0:+8GiB   --typecode=2:8200 \
         --new=3:0:0       --typecode=3:8300 \
           /dev/${DSKSLC}

#Partition the drive and create subvolumes
mkfs.fat -F 32 -n EFI /dev/sda1 
mkswap -L swap -f /dev/sda2 
mkfs.ext4 /dev/sda3 --label=nixos -f
mount /dev/disk/by-label/nixos /mnt
