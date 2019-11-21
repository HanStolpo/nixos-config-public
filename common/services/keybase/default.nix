{ config, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      #keybase-gui
      #keybase
    ];
  services.keybase.enable = true;
  services.kbfs.enable = true;

}
