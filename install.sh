#!/bin/sh
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
parted "/dev/${DSKSLC}" -- mklabel gpt
parted "/dev/${DSKSLC}" -- mkpart primary 512MiB -8GiB
parted "/dev/${DSKSLC}" -- mkpart primary linux-swap -8GiB 100%
parted "/dev/${DSKSLC}" -- mkpart ESP fat32 1MiB 512MiB
parted "/dev/${DSKSLC}" -- set 3 esp on
wait $!
sleep 2
#Partition the drive and create subvolumes

mkfs.ext4 -L nixos "/dev/${DSKSLC}1"
mkswap -L swap "/dev/${DSKSLC}2" 
mkfs.fat -F 32 -n boot "/dev/${DSKSLC}3"
wait $!
sleep 2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
}

## init phase
Select_Disk
Confirm
Format_Disk
echo "fin!"