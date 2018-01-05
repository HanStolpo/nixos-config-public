{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

     trayer # A lightweight GTK2-based systray for UNIX desktop

     # # haskell packages for XMonad
     pkgs.haskellPackages.xmobar
     # pkgs.haskellPackages.xmonad
     # pkgs.haskellPackages.xmonad-contrib
     # pkgs.haskellPackages.xmonad-extras
     # pkgs.haskellPackages.xmonad-utils
     # #pkgs.haskellPackages.xmonad-wallpaper
     # pkgs.haskellPackages.xmonad-windownames
     # pkgs.haskellPackages.xmonad-entryhelper
     # # pkgs.haskellPackages.xmonad-eval
     xmonad-with-packages

     taffybar # desktop information bar intended for use with XMonad and similar window managers

     dmenu # A generic, highly customizable, and efficient menu for the X Window System
     xclip # Tool to access the X clipboard from a console application

     # Themes
     slimThemes.lunar

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
  ];

  nixpkgs.config = {

    packageOverrides = super:
    {
      haskellPackages = super.haskellPackages // super.haskellPackages.override {
        overrides = self: super: {
          # jailbreak window names to get past its old version bounds
          xmonad-windownames = pkgs.haskell.lib.doJailbreak super.xmonad-windownames;
        };
      };
    };
  };

  # desktop env
  services.xserver = {
    xkbOptions = "ctrl:nocaps";
    enable = true;
    layout = "us";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellpackages: with haskellpackages; [
        taffybar
        dbus
        xmonad-windownames
        xmonad-entryhelper
        xmobar
        xmonad
        xmonad-contrib
        xmonad-extras
        xmonad-utils
      ];
      };
    windowManager.default = "xmonad";
    desktopManager.xterm.enable = false;
    desktopManager.gnome3.enable = false;
    desktopManager.xfce.enable = true;
    desktopManager.enlightenment.enable = false;
    desktopManager.default = "none";
    displayManager = {
      slim = {
        enable = true;
        defaultUser = "handre";
      };
    };
  };

  services.dbus.enable = true;
  programs.ssh.startAgent = true;
}

