{
  config,
  pkgs,
  ...
}: {
  users.users.sky = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
}
