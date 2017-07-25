{ config, pkgs, ... }:
{
  networking = {
    extraHosts =
      ''
        127.0.0.1 circuithub.test
        127.0.0.1 projects.circuithub.test
        127.0.0.1 api.circuithub.test
        127.0.0.1 reactor.circuithub.test
      '';
  };
}
