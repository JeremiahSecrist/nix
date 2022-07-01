inputs:

{
    common          =   import ./common.nix         inputs;
    boot            =   import ./boot.nix           inputs;
    encryptedBoot   =   import ./encryptedBoot.nix  inputs;
    harden          =   import ./harden.nix         inputs;
    sound           =   import ./sound.nix          inputs;
    yubikey         =   import ./yubikey.nix        inputs;
    u2fLogin        =   import ./u2fLogin.nix       inputs;
    gnomeDesktop    =   import ./gnomeDesktop.nix   inputs;
    docker          =   import ./docker.nix         inputs;
    openssh         =   import ./openssh.nix        inputs;
}
