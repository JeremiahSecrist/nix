_: { config, pkgs, lib, ... }: 
{
    services.openssh = {
        enable = true;
        passwordAuthentication = false;
        permitRootLogin = false;
    };
    security.pam = {
        enableSSHAgentAuth = true;
        services.sudo.sshAgentAuth = true;
    };
}