_: { config, pkgs, ... }: 
{
    services = {
        pcscd.enable = true;
        yubikey-agent.enable = true;
    };
    programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}