{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixops # NixOS cloud provisioning and deployment tool
  ];

  virtualisation.libvirtd.enable = true;
  networking.firewall.checkReversePath = false;

  virtualisation.docker.enable = false;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.addNetworkInterface = true;
}
