#!/bin/sh
pushd ~/.dotfiles
git pull
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd