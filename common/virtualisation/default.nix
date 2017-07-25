{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixops # NixOS cloud provisioning and deployment tool
  ];

  virtualisation.virtualbox.host.enable = true;
}
