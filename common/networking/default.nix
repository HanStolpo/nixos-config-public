{ config, pkgs, ... }:
{
  networking = {
    nameservers = ["8.8.8.8" "8.8.8.4" "192.168.1.1" "192.168.100.1"];
    extraHosts =
      ''
        127.0.0.1 circuithub.test
        127.0.0.1 projects.circuithub.test
        127.0.0.1 api.circuithub.test
        127.0.0.1 reactor.circuithub.test
      '';
  };
}
