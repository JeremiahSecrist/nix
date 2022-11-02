_:
{ config, pkgs, lib, nixpkgs, ... }:

{
  #enable sysrq
  boot.kernel.sysctl = { "kernel.sysrq" = 1; };
  # base packages
  environment.systemPackages = with pkgs; [
    gnumake
    nano
    git
    git-secret

  ];

  nixpkgs.config.allowUnfree = true;
  nix = {

    # nix flakes
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #auto maintainence
    settings.auto-optimise-store = lib.mkDefault true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # prevent tampering
    readOnlyStore = true;

  };

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.utf8";

  # Performance
  # enable zram
  zramSwap.enable = lib.mkDefault true;
  # clock speed management
  # services.auto-cpufreq.enable = lib.mkDefault true;

}
