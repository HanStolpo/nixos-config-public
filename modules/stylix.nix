{ config, options, lib, pkgs, ... }:
{
  stylix.enable = true;

  # dynamically manage this in noctalia for now
  # stylix.image = ../wallpapers/wallhaven-lambda-green.jpg;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-dune.yaml";
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-plateau-light.yaml";

  stylix.cursor = {
    # https://github.com/catppuccin/cursors
    package = pkgs.catppuccin-cursors.latteSky;
    name = "catppuccin-latte-sky-cursors";
    size = 24;
  };

}
