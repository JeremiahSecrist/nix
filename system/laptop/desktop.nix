{ config, pkgs, ... }:

{
# enable xerver and cinnamon
hardware.opengl.enable = true ;
services.xserver = {
    enable = true;
    libinput.enable = true;
    layout = "us";
    displayManager.lightdm.enable = true;
    desktopManager = {
			cinnamon.enable = true;
		};
    displayManager.defaultSession = "cinnamon";
};

# pipewire support
security.rtkit.enable = true;
sound.enable = true;
services.pipewire = {
  enable = true;
  wireplumber.enable = true;
  # alsa = {
  #  enable = true;
  #  support32Bit = true;
  # }
  # pulse.enable = true;
};
}