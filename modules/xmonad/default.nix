{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.xmonad;
in
{
  options = {
    hanstolpo.xmonad = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      xdotool # x desktop automation
      xclip # terminal clipboard support

      # fonts
      xorg.mkfontdir
      xfontsel
      xlsfonts

      stalonetray # Stalonetray is a stand-alone freedesktop.org and KDE system tray (notification area) for X Window System/X11 
      (haskell.lib.justStaticExecutables haskellPackages.xmobar)
      unclutter-xfixes
      capitaine-cursors
      dmenu # A generic, highly customizable, and efficient menu for the X Window System
      libnotify # A library that sends desktop notifications to a notification daemon
      xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
      xdg_utils # A set of command line tools that assist applications with a variety of desktop integration tasks
      xorg.xcursorthemes
      xorg.xev
      xorg.xprop

      notify-osd # Daemon that displays passive pop-up notifications

    ];

    services.unclutter-xfixes = {
      enable = true;
    };
    services.xserver = {
      xkbOptions = "ctrl:nocaps";
      enable = true;
      layout = "us";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellpackages: with haskellpackages; [
          dbus
          # xmonad-entryhelper
          xmobar
          xmonad
          xmonad-contrib
          xmonad-extras
          xmonad-utils
        ];
      };
      displayManager.defaultSession = "none+xmonad";

      displayManager = {

        lightdm = {
          enable = true;
          greeters.mini = {
            enable = true;
            user = "handre";
          };
        };
      };
    };

    services.dbus.enable = true;
  };
}
