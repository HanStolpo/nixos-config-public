{ config, pkgs, ... }:
{
  environment.systemPackages =
  with pkgs;
  [
     xlibs.mkfontdir
     xfontsel
     xlsfonts
     powerline-fonts
  ];

  fonts = {
   enableFontDir = true;
   enableGhostscriptFonts = true;
   fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      powerline-fonts
      ];
   fontconfig = {
     defaultFonts = {
       monospace = ["Roboto Mono for Powerline"];
     };
   };
  };
}
