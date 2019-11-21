{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kicad # Free Software EDA Suite
    eagle # Eagle EDA tool
    gerbv # A Gerber (RS-274X) viewer
  ];
}
