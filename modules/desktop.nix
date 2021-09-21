{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.hanstolpo.desktop;
in
{
  options = {
    hanstolpo.desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      # terminals
      termite # vi like terminal easy to customize
      alacritty # vi like terminal emulator which is OpenGL accelerated

      xdotool # x desktop automation
      flameshot # easy screenshot tool
      shutter # take screen shots annotate images
      gv # postscript viewer
      ghostscript # 
      zoom-us # video chat client
      inkscape # Vector graphics editor
      obs-studio # Free and open source software for video recording and live streaming
      projectlibre # Project-Management Software similar to MS-Project
      libreoffice # Comprehensive, professional-quality productivity suite (Still/stable release)
      #adobe-reader # PDF viewer
      gimp # The GNU Image Manipulation Program
      vlc # Cross-platform media player and streaming server
      mpv # A media player that supports many video formats (MPlayer and mplayer2 fork)
      ffmpeg-full # A complete, cross-platform solution to record, convert and stream audio and video
      remmina # remote desktop client
      realvnc-viewer
      xclip # terminal clipboard support
      gnome3.nautilus # the gnome file manager

      # browsers
      firefox
      google-chrome
      firefox-devedition-bin

      # chat clients
      slack
      discord
      weechat # A fast, light and extensible chat client

      # online storage
      dropbox # to stop dropbox from auto updating create ~/.dropbox-dist chmod 0 it
      dropbox-cli

      #EDA
      #kicad # Free Software EDA Suite
      #eagle # Eagle EDA tool
      gerbv # A Gerber (RS-274X) viewer

      gnome3.glade # gtk layout tool

      # fonts
      xlibs.mkfontdir
      xfontsel
      xlsfonts
      powerline-fonts

      trayer # A lightweight GTK2-based systray for UNIX desktop
      stalonetray # Stalonetray is a stand-alone freedesktop.org and KDE system tray (notification area) for X Window System/X11 
      (haskell.lib.justStaticExecutables haskellPackages.xmobar)
      unclutter-xfixes
      capitaine-cursors
      dmenu # A generic, highly customizable, and efficient menu for the X Window System
      libnotify # A library that sends desktop notifications to a notification daemon
      xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
      xdg_utils # A set of command line tools that assist applications with a variety of desktop integration tasks
      xlibs.xcursorthemes
      xlibs.xev
      xlibs.xprop

      notify-osd # Daemon that displays passive pop-up notifications

      sqlitebrowser

      rhythmbox # music player

      sweethome3d.application # floor plan interior design application

      languagetool

      fontforge-gtk
    ];

    nixpkgs.config = {
      packageOverrides = super:
        {
          google-chrome = super.google-chrome.override { channel = "stable"; };
        };
    };
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        corefonts # Micrsoft free fonts
        inconsolata # monospaced
        ubuntu_font_family # Ubuntu fonts
        unifont # some international languages
        powerline-fonts
        nerdfonts
        font-awesome
      ];
      fontconfig = {
        defaultFonts = {
          monospace = [ "Roboto Mono for Powerline" ];
        };
      };
    };
    services.unclutter-xfixes = {
      enable = true;
    };
    services.xserver = {
      useGlamor = true;
      xkbOptions = "ctrl:nocaps";
      enable = true;
      layout = "us";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellpackages: with haskellpackages; [
          dbus
          xmonad-entryhelper
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
