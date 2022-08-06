_:
{ config, pkgs, lib, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # base packages
  environment.systemPackages = with pkgs; [
    gnumake
    nano
    git
    git-secret

  ];

  nix = {
    # settings = {
    #   substituters = [
    #     "https://cache.arouzing.win"
    #     # "https://nix-community.cachix.org"
    #     # "https://cache.nixos.org/"
    #   ];
    #   trusted-public-keys = [
    #     "cache.arouzing.win:cj4W/bmYZQ9brOGZBMDOeEflbwMihdMBztt8Qklza1o="
    #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #   ];
    # };
    # nix flakes
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #auto maintainence
    autoOptimiseStore = lib.mkDefault true;
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
  services.auto-cpufreq.enable = lib.mkDefault true;

}
