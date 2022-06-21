inputs:

{
    common          =   import ./common         inputs;
    boot            =   import ./boot           inputs;
    encryptedBoot   =   import ./encryptedBoot  inputs;
    harden          =   import ./harden         inputs;
    sound           =   import ./sound          inputs;
    yubikey         =   import ./yubikey        inputs;
    u2fLogin        =   import ./u2fLogin       inputs;
    gnomeDesktop    =   import ./gnomeDesktop   inputs;

}
