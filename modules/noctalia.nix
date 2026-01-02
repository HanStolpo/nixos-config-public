{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hanstolpo.noctalia;
  hmUsers = config.hanstolpo.home-manager.users;
in
{
  options = {
    hanstolpo.noctalia = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable noctalia shell configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs hmUsers (user: { pkgs, ... }: {
      imports = [
        ./home/noctalia.nix
      ];
    });

    environment.systemPackages = with pkgs; [
      noctalia-shell
    ];

    # Enable services required by noctalia to function properly
    # https://docs.noctalia.dev/getting-started/nixos/
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.tuned.enable = true;
    services.upower.enable = true;
    services.noctalia-shell.enable = true;
  };
}
