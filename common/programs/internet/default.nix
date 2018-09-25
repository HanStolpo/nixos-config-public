{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     # browsers
     firefox
     google-chrome

     # chat clients
     hipchat
     #hipchat
     slack
     weechat # A fast, light and extensible chat client

     # online storage
     dropbox         # to stop dropbox from auto updating create ~/.dropbox-dist chmod 0 it
     dropbox-cli

     cifs-utils # Tools for managing Linux CIFS client filesystems
     nfs-utils # This package contains various Linux user-space Network File System (NFS) utilities, including RPC `mount' and `nfs' daemons.

  ];

  nixpkgs.config = {
    firefox = {
      enableGnash = true;
      #enableAdobeFlash = true;
      icedtea = true;
      #jre = true;
      enableGoogleTalkPlugin = true;
      enableDjvu = true;
      enableGnomeExtensions = true;
      #enableVLC = true;
    };
    firefox-bin = {
      #enableGnash = true;
      enableAdobeFlash = true;
      #icedtea = true;
      jre = true;
      enableGoogleTalkPlugin = true;
      enableDjvu = true;
      enableGnomeExtensions = true;
      enableVLC = true;
    };
    firefox-esr = {
      #enableGnash = true;
      enableAdobeFlash = true;
      #icedtea = true;
      jre = true;
      enableGoogleTalkPlugin = true;
      enableDjvu = true;
      enableGnomeExtensions = true;
      enableVLC = true;
    };
    # chromium = {
    #   enablePepperFlash = true;
    #   enablePepperPDF = true;
    #   enableNaCl = true;
    #   gnomeSupport = true;
    #   gnomeKeyringSupport = true;
    #   pulseSupport = true;
    #   hiDPISupport = true;
    #   enableWideVine = true; # for encrypted media eg netflix
    # };

    packageOverrides = super:
    {
      google-chrome = super.google-chrome.override {channel = "stable";};
    };
  };
}

