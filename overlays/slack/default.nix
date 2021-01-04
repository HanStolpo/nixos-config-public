final: prev:
{
  slack = final.callPackage ./slack.nix { gdk-pixbuf = final.gdk_pixbuf; };
}
