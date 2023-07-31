{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/nixos/stylix.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/desktop/sound.nix
    ../../modules/nixos/desktop/lemurs.nix
    ../../modules/nixos/disks/encryptedBoot.nix #{ installDir = "/dev/sda"; }
    ../../modules/nixos/kernel/sysctl.nix
    ../../modules/nixos/networking/nm.nix
    ../../modules/nixos/networking/tailscale.nix
    ../../modules/nixos/nix/flakes.nix
    ../../modules/nixos/nix/registry.nix
    ../../modules/nixos/nix/garbage-collection.nix
    ../../modules/nixos/nix/unfree.nix
    ../../modules/nixos/packages/base.nix
    ../../modules/nixos/packages/flatpak.nix
    # ../../modules/nixos/performance/cpufreq.nix
    ../../modules/nixos/performance/power-management.nix
    ../../modules/nixos/performance/zram.nix
    # ../../modules/nixos/services/grafana.nix
    # ../../modules/nixos/services/prometheus.nix
    # ../../modules/nixos/services/loki
    ../../modules/nixos/regional/locale.nix
    ../../modules/nixos/security/yubikey.nix
    #../../modules/nixos/security/u2fLogin.nix
    ../../modules/nixos/shell/zsh.nix
    # ../../modules/nixos/virtualization/docker.nix
    # ../../modules/nixos/virtualization/libvirt.nix
    ../../modules/users/sky.nix
  ];
}
