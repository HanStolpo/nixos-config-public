{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hanstolpo.cosmic;
  hmUsers = config.hanstolpo.home-manager.users;
in
{
  options = {
    hanstolpo.cosmic = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the COSMIC desktop environment with the cosmic-greeter";
      };
      autoLoginUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Automatically log in this user via the cosmic-greeter";
      };
      wallpaperDirectory = mkOption {
        type = types.str;
        default = "";
        description = "Directory with wallpapers for COSMIC to rotate through";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users = genAttrs hmUsers (user: { pkgs, ... }: {
      imports = [
        ./home/cosmic.nix
      ];
    });

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    services.displayManager.autoLogin = mkIf (cfg.autoLoginUser != null) {
      enable = true;
      user = cfg.autoLoginUser;
    };

    # COSMIC's network applet is built on NetworkManager
    networking.networkmanager.enable = true;

    environment.variables.NIXOS_OZONE_WL = "1";

    # Allow clipboard managers to access the wayland data control protocol
    # https://wiki.nixos.org/wiki/COSMIC
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
  };
}
