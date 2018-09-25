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
      netConf = "192.168.178.220";
      #extraBackends = [pkgs.sane-backends];
    };
  };

}
