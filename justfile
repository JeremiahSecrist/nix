base := "sudo nixos-rebuild"
flake := "--flake .#"

default:
    echo 'available command: vm, build, test, boot, switch'

vm:
    {{base}} build-vm {{flake}}

run-vm: vm
    ./result/bin/run-*-vm

switch:
    {{base}} switch {{flake}}

boot:
    {{base}} boot {{flake}}

build:
    {{base}} build {{flake}}

test:
    {{base}} test {{flake}}

dry:
    {{base}} dry-build {{flake}}

fmt:
    alejandra .

clean:
    sudo nix-collect-garbage -d
    sudo nix store optimise
    nix-collect-garbage -d
    nix store optimise
