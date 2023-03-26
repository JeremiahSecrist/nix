# nix
This is my installer script and configuration of nixos I will be using this repor to manage varrios install with nixos for testing and future uses.

# disko
#### This formats the disk
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode zap_create_mount /tmp/disko-config.nix --arg disks '[ "/dev/nvme0n1" ]'

