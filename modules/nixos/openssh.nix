_: { config, pkgs, lib, ... }: 
{
    services.openssh = {
        enable = true;
        passwordAuthentication = false;
        permitRootLogin = "no";
    };
    security.pam = {
        enableSSHAgentAuth = true;
        services.sudo.sshAgentAuth = true;
    };
}