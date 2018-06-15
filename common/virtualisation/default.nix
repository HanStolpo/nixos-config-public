{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixops # NixOS cloud provisioning and deployment tool
  ];

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.addNetworkInterface = false;
}
