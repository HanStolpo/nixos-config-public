{ config, pkgs, ... }:
{
  environment.systemPackages =
  with pkgs;
  [
    simple-scan # Simple scanning utility
  ];

  services = {
    printing = {
      enable = true;
      #gutenprint = true; # deprecated
      drivers = [pkgs.gutenprint pkgs.hplip pkgs.splix];
    };
  };

  hardware = {
    sane = {
      enable = true;
      #extraBackends = [pkgs.sane-backends];
    };
  };

}
