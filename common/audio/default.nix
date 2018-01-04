{ config, pkgs, ... }:
let pkgs-17-0-9 = import (pkgs.fetchgit
      {
        url= "https://github.com/nixos/nixpkgs-channels";
        rev= "3aec59c99ff6692468a069fa8a8d6a05000fca81";
        sha256= "1w0mrsbmpfh3kxl8xkg7jccny709dammjn1lnbnrn3xx8bndsmnp";
        fetchSubmodules= true;
      }) {config = {allowUnfree = true;};};
in
{
  environment.systemPackages = with pkgs-17-0-9; [
     pavucontrol
     pasystray
     pulseaudioFull
  ];

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs-17-0-9.pulseaudioFull;
    };
  };

}
