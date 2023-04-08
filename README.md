# nix
This is my installer script and configuration of nixos I will be using this repor to manage varrios install with nixos for testing and future uses.

# disko
#### This formats the disk
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode mount modules/disko/lvm-luks.nix --arg disks '[ "/dev/disk/by-id/usb-_USB_DISK_3.2_0700199604A32D02-0:0" ]'

sudo  nixos-install --flake .#framework-laptop