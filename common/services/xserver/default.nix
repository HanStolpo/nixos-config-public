{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    trayer # A lightweight GTK2-based systray for UNIX desktop
    stalonetray # Stalonetray is a stand-alone freedesktop.org and KDE system tray (notification area) for X Window System/X11 
    (haskell.lib.justStaticExecutables haskellPackages.xmobar)
    unclutter-xfixes
    capitaine-cursors

    # # # haskell packages for XMonad
    # # pkgs.haskellPackages.xmonad-eval
    # (
    #   xmonad-with-packages.override {
    #     packages = self: with self;
    #       [
    #         xmonad
    #         xmobar
    #         xmonad-contrib
    #         xmonad-extras
    #         xmonad-utils
    #         #xmonad-windownames
    #         xmonad-entryhelper
    #         #taffybar
    #       ];
    #   }
    # )


    #taffybar # desktop information bar intended for use with XMonad and similar window managers

    dmenu # A generic, highly customizable, and efficient menu for the X Window System
    xclip # Tool to access the X clipboard from a console application

    # Themes
    #slimThemes.lunar

    libnotify # A library that sends desktop notifications to a notification daemon
    xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
    xdg_utils # A set of command line tools that assist applications with a variety of desktop integration tasks
    xlibs.xcursorthemes
    xlibs.xev
    xlibs.xprop

    notify-osd # Daemon that displays passive pop-up notifications

    # screen capture
    slop # select a screen area
    maim # create a screen shot (can be driven by slop)

    xorg.xinit # for startx when messing around with extra displays or playing with xmonad

    xorg.xbacklight # control backlight of screen

    #(haskell.lib.justStaticExecutables haskellPackages.status-notifier-item)

    # https://github.com/NixOS/nixpkgs-channels/blob/nixos-20.03/pkgs/build-support/make-desktopitem/default.nix
    # https://wiki.haskell.org/Xmonad/Using_xmonad_in_MATE
    # [Desktop Entry]
    # Type=Application
    # Name=XMonad
    # Exec=/usr/bin/xmonad
    # NoDisplay=true
    # X-GNOME-WMName=XMonad
    # X-GNOME-Autostart-Phase=WindowManager
    # X-GNOME-Provides=windowmanager
    # X-GNOME-Autostart-Notify=true
    # (
    #   let
    #     xmonadSession =
    #       builtins.elemAt
    #         (
    #           pkgs.lib.filter (s: s.name == "xmonad")
    #             config.services.xserver.displayManager.session
    #         ) 0;
    #   in
    #     makeDesktopItem
    #       {
    #         desktopName = "XMonad";
    #         name = "XMonad";
    #         exec = xmonadSession.start;
    #         extraEntries = ''
    #           NoDisplay=true
    #           X-GNOME-WMName=XMonad
    #           X-GNOME-Autostart-Phase=WindowManager
    #           X-GNOME-Provides=windowmanager
    #           X-GNOME-Autostart-Notify=true
    #         '';
    #       }
    # )
  ];

  services.unclutter-xfixes = {
    enable = true;
  };

  # desktop env
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
  programs.ssh.startAgent = true;

}
