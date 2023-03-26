{ config, ... }:

  let 
    modulesPath = ../../modules;
  in
  {
    import = [
      modulesPath + /nixos/desktop/gnome.nix
      modulesPath + /nixos/disks/encryptedBoot.nix { installDir = "/dev/sda"; }
      modulesPath + /nixos/kernel/sysctl.nix
      modulesPath + /nixos/networking/nm.nix
      modulesPath + /nixos/networking/tailscale.nix
      modulesPath + /nixos/nix/flakes.nix
      modulesPath + /nixos/nix/garbage-collection.nix
      modulesPath + /nixos/nix/unfree.nix
      modulesPath + /nixos/packages/base.nix
      modulesPath + /nixos/packages/flatpak.nix
      modulesPath + /nixos/performance/cpufreq.nix
      modulesPath + /nixos/performance/power-management.nix
      modulesPath + /nixos/performance/zram.nix
      modulesPath + /nixos/regional/locale.nix
      modulesPath + /nixos/security/yubikey.nix
      modulesPath + /nixos/security/u2fLogin.nix
      modulesPath + /nixos/shell/zsh.nix
      modulesPath + /nixos/virtualization/docker.nix
      modulesPath + /nixos/virtualization/libvirt.nix
      modulesPath + /users/sky.nix
    ];
  }