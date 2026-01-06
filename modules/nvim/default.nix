{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hanstolpo.nvim;
  hmUsers = config.hanstolpo.home-manager.users;
in
{
  options = {
    hanstolpo.nvim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable neovim configuration via home-manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs hmUsers (user: { pkgs, ... }: {
      imports = [
        ../home/nvim.nix
      ];
    });
  };
}
