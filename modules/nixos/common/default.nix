_: { config, pkgs, lib, ... }:

{
     # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # base packages
    environment.systemPackages = with pkgs; [
        gnumake
        nano
        git
    ];

    nix = {
    # nix flakes
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #auto maintainence
    autoOptimiseStore = true;
        gc ={
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
    };

    # Bootloader.
    boot.plymouth.enable = true;
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 1;
    };

    # enable zram
    zramSwap.enable = true;

    # enable docker
    virtualisation = {
    docker.liveRestore = false;
        docker = {
        enable = true;
        };
    };

}