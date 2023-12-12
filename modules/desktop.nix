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
      alacritty # vi like terminal emulator which is OpenGL accelerated

      #flameshot # easy screenshot tool
      shutter # take screen shots annotate images
      gv # postscript viewer
      ghostscript # 
      #zoom-us # video chat client
      #teams
      inkscape # Vector graphics editor
      obs-studio # Free and open source software for video recording and live streaming
      #projectlibre # Project-Management Software similar to MS-Project
      libreoffice # Comprehensive, professional-quality productivity suite (Still/stable release)
      #adobe-reader # PDF viewer
      gimp # The GNU Image Manipulation Program
      vlc # Cross-platform media player and streaming server
      mpv # A media player that supports many video formats (MPlayer and mplayer2 fork)
      ffmpeg-full # A complete, cross-platform solution to record, convert and stream audio and video
      remmina # remote desktop client
      #realvnc-viewer
      #gnome3.nautilus # the gnome file manager
      cinnamon.nemo-with-extensions    # file manager
      viewnior # light weight image viewer

      # browsers
      firefox
      pkgs-unstable.google-chrome
      firefox-devedition-bin

      # chat clients
      pkgs-unstable.slack
      pkgs-unstable.discord
      weechat # A fast, light and extensible chat client

      # # online storage
      # # use 'drop-cli' instead of 'dropbox'. Both have an executable called 'dropbox' so if you have both
      # # its unclear which one will end up in '/run/current-system/sw/bin'. 'dropbox-cli' seems to work better
      # # and is more up to date, 'dropbox' failed to log in. Start the daemon by doing 'dropbox start'.
      # pkgs-unstable.dropbox-cli
      pkgs-unstable.dropbox

      #EDA
      #kicad # Free Software EDA Suite
      #eagle # Eagle EDA tool
      #gerbv # A Gerber (RS-274X) viewer

      #glade # gtk layout tool

      sqlitebrowser

      #rhythmbox # music player

      #sweethome3d.application # floor plan interior design application

      languagetool

      #fontforge-gtk

      pinentry-qt # qt based pinentry program to be used with gpg

      gnvim # minimal gui front end for nvim

      d2 # text based diagram drawing program
      tala # layout engine for D2
      mdsync # render and live reload markdown
    ];


    nixpkgs.config = {
      packageOverrides = super:
        {
          google-chrome = super.google-chrome.override { channel = "stable"; };
        };
    };

    # derived from here https://github.com/danielbarter/nixos-config/blob/36e173ac251a3380a026c0ccb90c3612a627b761/configuration.nix#L268
    fonts = {
      fontDir.enable = true;

      enableGhostscriptFonts = true;

      packages = with pkgs; [
        corefonts          # Micrsoft free fonts
        inconsolata        # monospaced
        ubuntu_font_family # Ubuntu fonts
        unifont            # some international languages
        powerline-fonts
        nerdfonts
        font-awesome_5

        source-code-pro
        source-sans-pro
        source-serif-pro
        noto-fonts-emoji
      ];

      enableDefaultPackages = true;

      fontconfig = {
        enable = true;

        # copied from https://github.com/danielbarter/nixos-config/blob/36e173ac251a3380a026c0ccb90c3612a627b761/configuration.nix#L281
        #
        # some applications, notably alacritty, choose fonts according to
        # fontconfigs internal ordering of fonts rather than specific font
        # tags. To get the correct fonts to be rendered, we need to disable some
        # fallback fonts which nixos includes by default and fontconfig prefers
        # over user specified ones. To see this internal list, run fc-match -s

        localConf = let
          # function to generate patterns for fontconfig font banning
          fontBanPattern = s: ''
          <pattern>
            <patelt name="family">
              <string>${s}</string>
            </patelt>
          </pattern>
          '';

          fontsToBan = [
            "Noto Emoji"
            "DejaVu Sans"
            "FreeSans"
            "FreeMono"
            "FreeSerif"
            "DejaVu Math TeX Gyre"
            "DejaVu Sans Mono"
            "DejaVu Serif"
            "Liberation Mono"
            "Liberation Serif"
            "Liberation Sans"
            "DejaVu Serif"
            "DejaVu Serif"
            "Liberation Serif"
            "DejaVu Serif"
          ]; in
          ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <selectfont>
              <rejectfont>
                ${lib.strings.concatStringsSep "\n" (map fontBanPattern fontsToBan)}
              </rejectfont>
            </selectfont>
          </fontconfig>
        '';

        defaultFonts = {
          monospace = [ "Roboto Mono for Powerline" ];
          sansSerif = [ "Source Sans Pro" ];
          serif     = [ "Source Serif Pro" ];
          emoji     = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
