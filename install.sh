cp ./modules/nixos/disks/impermanence.nix /tmp/disko.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/refs/tags/v1.3.0 -- --mode $3 /tmp/disko.nix --arg device '"$1"' --arg device '"$2"'
nixos-install --flake .\#$4