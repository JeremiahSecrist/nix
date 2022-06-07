#!/bin/sh
source laptop.env
pushd ~/.dotfiles
git pull
sudo nixos-rebuild switch -I nixos-config=./system/${SYSTEM_NAME}/configuration.nix
popd