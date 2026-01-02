{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hanstolpo.home-manager;
in
{
  options = {
    hanstolpo.home-manager = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable home-manager configuration";
      };

      users = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of users to configure with home-manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs cfg.users (user: { pkgs, ... }: {
      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.11";

      imports = [
        ./home/general.nix
        ./home/fish.nix
        ./home/git.nix
      ];
    });
  };
}
