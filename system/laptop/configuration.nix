# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];
 
  networking = {
    hostName = "skytop"; # Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";

  # ssd optimization:
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  # bluetooth
  hardware.bluetooth.enable = true;

  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  # fixes gnome login issues
  programs.zsh.enable = true;
  systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  services = {
    flatpak.enable = true;
    fwupd.enable = true;
    xserver.libinput.enable = true;
    tlp = {
      enable = false;
    #   settings = {
    #     CPU_BOOST_ON_BAT = 0;
    #     CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
    #     START_CHARGE_THRESH_BAT0 = 90;
    #     STOP_CHARGE_THRESH_BAT0 = 97;h
    #     RUNTIME_PM_ON_BAT = "auto";
    #   };
    };
    thermald.enable = true;
    # auto-cpufreq.enable = true;
    power-profiles-daemon.enable = false;
  };
  boot.kernel.sysctl = {
  "kernel.nmi_watchdog" = 0;
  "vm.dirty_writeback_centisecs" = 6000;
  "vm.laptop_mode" = 5;
  };
  powerManagement = {
   enable = true;
   powertop.enable = true;
   scsiLinkPolicy = "med_power_with_dipm";
  };
  # powerManagement.cpufreq.max = 2000000;
  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
