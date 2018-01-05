{ config, pkgs, ... }:

let pkgs-17-0-9 = import (pkgs.fetchgit
      {
        url= "https://github.com/nixos/nixpkgs-channels";
        rev= "7f6f0c49f0e8d24346bd32c3dec20cc60108a005";
        sha256= "1k6p0ayv5riqm4bnyxpd1aw9l34dk96qk9vngmd08lr7h8v3s285";
        fetchSubmodules= true;
      }) {config = {allowUnfree = true;};};
in
{

  environment.systemPackages = with pkgs; [
     # browsers
     firefox-esr
     google-chrome

     # chat clients
     pkgs-17-0-9.hipchat
     #hipchat
     slack
     weechat # A fast, light and extensible chat client

     # online storage
     dropbox         # to stop dropbox from auto updating create ~/.dropbox-dist chmod 0 it
     dropbox-cli

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
      enableVLC = true;
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

