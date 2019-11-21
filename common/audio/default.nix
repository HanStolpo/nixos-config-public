{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    pasystray
    pulseaudioFull
  ];

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

}
