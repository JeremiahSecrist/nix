#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/sky/home.nix
popd