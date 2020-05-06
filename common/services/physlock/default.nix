{ config, pkgs, ... }:
{

  services.physlock.enable = false;
  services.physlock.lockOn.hibernate = false;
  services.physlock.lockOn.suspend = true;

}
