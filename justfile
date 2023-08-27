base := "sudo nixos-rebuild"
flake := "--flake .#"

default:
    echo 'available command: vm, build, test, boot, switch'

vm:
    {{base}} build-vm {{flake}}

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
