_: { config, pkgs, lib, ... }: 
{
    services.openssh = {
        enable = true;
        openFirewall = true;
        startWhenNeeded = true;
        kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
        passwordAuthentication = false;
        permitRootLogin = "no";
        # extraConfig = ''
        #     AllowTcpForwarding
        # '';
    };
    security.pam = {
        enableSSHAgentAuth = true;
        services.sudo.sshAgentAuth = true;
    };
}