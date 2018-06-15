{ config, pkgs, ... }:
{

  services.physlock.enable = true;
  services.physlock.lockOn.hibernate = false;
  services.physlock.lockOn.suspend = true;

}
