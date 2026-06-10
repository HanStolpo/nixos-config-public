{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.niri;
  hmUsers = config.hanstolpo.home-manager.users;

in
{
  options = {
    hanstolpo.niri = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      autoLoginUser = mkOption {
        type = types.str;
      };
    };
  };
  config = mkIf cfg.enable {
    home-manager.users = genAttrs hmUsers (user: { pkgs, ... }: {
      imports = [
        ./home/niri.nix
      ];
    });

    #programs.niri.package = pkgs.pkgs-unstable.niri;
    programs.niri.package = pkgs.niri-unstable;

    environment.systemPackages = with pkgs; [
      brightnessctl # backlight control (replacement for programs.light)
      alacritty # gpu accelerated terminal
      wayland
      glib # gsettings
      gsettings-desktop-schemas
      grim # for screenshots
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      xdg-desktop-portal-wlr # desktop portal functionality for wlroots based systems
      qt6.qtwayland # support for qt applications on wayland
      fuzzel
      xwayland-satellite
      nautilus # the gnome file manager

      brightnessctl

      # theming
      papirus-icon-theme # icon package to use with fuzzel
      papirus-folders
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      kdePackages.breeze
      colloid-gtk-theme # the GTK desktop theme used
    ];

    # make the fonts accessbile in /run/current/sw/share/X11/fonts
    # so that dependant applications can find it easier
    fonts.fontDir.enable = true;

    fonts.packages = with pkgs;[
      source-code-pro # font used by fuzzel
      # font used for icons in waybar
      nerd-fonts.symbols-only
      nerd-fonts.roboto-mono
    ];

    # xdg-desktop-portal works by exposing a series of D-Bus interfaces
    # known as portals under a well-known name
    # (org.freedesktop.portal.Desktop) and object path
    # (/org/freedesktop/portal/desktop).
    # The portal interfaces include APIs for file access, opening URIs,
    # printing and others.
    services.dbus.enable = true;
    # xdg.portal = {
    #   enable = true;
    #   wlr.enable = true;
    #   wlr.settings.screencast = {
    #     max_fps = 30;
    #     chooser_type = "simple";
    #     chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    #   };
    #   # gtk portal needed to make gtk apps happy
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # };

    security.pam.services.greetd = {
        enableGnomeKeyring = true;
    };
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
          user = cfg.autoLoginUser;
          command = "niri-session";
        };
        initial_session = {
          user = cfg.autoLoginUser;
          command = "niri-session";
        };
      };
    };

    # niri
    programs.niri.enable = true;
    environment.variables.NIXOS_OZONE_WL = "1";
    niri-flake.cache.enable = false;
    #stylix.targets.niri.enable = false;
  };
}
