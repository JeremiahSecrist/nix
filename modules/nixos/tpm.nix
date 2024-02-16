{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.tmp;
  inherit (lib) mkIf mkEnableOption;
  tctiCfg = config.security.tpm2.tctiEnvironment;
  pkg = pkgs.tpm2-tss;
  tctiOption =
    if tctiCfg.interface == "tabrmd"
    then tctiCfg.tabrmdConf
    else tctiCfg.deviceConf;
  tcti = "${tctiCfg.interface}:${tctiOption}";
in {
  options.local.tmp.enable = mkEnableOption "a";
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        tpm2-pkcs11 = prev.tpm2-pkcs11.override {fapiSupport = false;};
      })
    ];
    services.pcscd.enable = true;
    programs.ssh.startAgent = true;
    programs.ssh.agentPKCS11Whitelist = "${pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11*";
    security = {
      tpm2 = {
        enable = true;
        pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
        tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
        applyUdevRules = true;
      };
    };
    users.users.sky.extraGroups = ["tss"];
    environment.sessionVariables = {
      TSS2_FAPICONF = pkgs.runCommand "fapi-config.json" {} ''
        cp ${pkg}/etc/tpm2-tss/fapi-config.json $out
        sed -i 's|/nix/store/[^/]*/var|/var|' $out
        sed -i 's|"tcti":.*$|"tcti": "${tcti}",|' $out
      '';
      TPM2TOOLS_TCTI = tcti;
      TPM2_PKCS11_TCTI = tcti;
    };
  };
}
