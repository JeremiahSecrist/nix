_: { config, pkgs, ... }: 
{
    services = {
        pcscd.enable = true;
        yubikey-agent.enable = true;
    }
}