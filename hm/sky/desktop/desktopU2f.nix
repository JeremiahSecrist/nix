{ config, pkgs, stdenv, lib, ... }:
{
    home.file = {
        u2fKeys = {
            target = ".config/Yubico/u2f_keys";
            text = "sky:Rk7isBsz5cxGjIKat8frt2ABz1yfLFpkzep8gKbcoDVJepELWRU0grMTkvoedI38ZmM5lHXT8qEDne5RTxoKAQ==,Z1BAJjqxpMuLoh6vmfsGQVWq44TA8WDlCpM9pV38qEBtFB8qgnwBV95CCdHqkSUNxpUR9XiEbylqKjV/c5ML/w==,es256,+presence";
        };
    };
}