{ config, pkgs, ... }:
{
  services = {
    rabbitmq.enable = true;
  };
}

