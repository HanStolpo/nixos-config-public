{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [

    remmina # remote desktop client
    wireguard

    # browsers
    firefox
    google-chrome

    # chat clients
    slack
    discord
    weechat # A fast, light and extensible chat client

    # online storage
    dropbox # to stop dropbox from auto updating create ~/.dropbox-dist chmod 0 it
    dropbox-cli

    cifs-utils # Tools for managing Linux CIFS client filesystems
    nfs-utils # This package contains various Linux user-space Network File System (NFS) utilities, including RPC `mount' and `nfs' daemons.

  ];

  nixpkgs.config = {
    packageOverrides = super:
      {
        google-chrome = super.google-chrome.override { channel = "stable"; };
      };
  };
}
