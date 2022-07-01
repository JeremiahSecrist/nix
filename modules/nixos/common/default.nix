_: { config, pkgs, lib, ... }:

{
     # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # base packages
    environment.systemPackages = with pkgs; [
        gnumake
        nano
        git
        git-secret

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
        # prevent tampering
        readOnlyStore = true;

    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.utf8";

    # Performance
    # enable zram
    zramSwap.enable = true;
    # clock speed management
    services.auto-cpufreq.enable = true;
    # enable docker
    virtualisation = {
    docker.liveRestore = false;
        docker = {
        enable = true;
        };
    };

}