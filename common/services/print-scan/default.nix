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
      gutenprint = true;
    };
  };

  # hardware = {
  #   sane = {
  #     enable = true;
  #     extraBackends = [pkgs.sane-backends];
  #   };
  # };

}
