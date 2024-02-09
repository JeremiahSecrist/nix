cp ./modules/nixos/disks/impermanence.nix /tmp/disko.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/refs/tags/v1.3.0 -- --mode $1 /tmp/disko.nix --arg device '"/dev/nvme0n1"' --arg swapSize '"8G"'
nixos-install --flake .\#lappy