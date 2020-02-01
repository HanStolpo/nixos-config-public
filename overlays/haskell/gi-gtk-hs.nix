{ mkDerivation, base, base-compat, containers, gi-gdk, gi-gdkpixbuf
, gi-glib, gi-gobject, gi-gtk, haskell-gi-base, mtl, stdenv, text
, transformers
}:
mkDerivation {
  pname = "gi-gtk-hs";
  version = "0.3.8.0";
  sha256 = "b4c4fc2936a24be471243460f4b3359096ddc989d84018566ff14a47049efe32";
  libraryHaskellDepends = [
    base base-compat containers gi-gdk gi-gdkpixbuf gi-glib gi-gobject
    gi-gtk haskell-gi-base mtl text transformers
  ];
  jailbreak = true;
  homepage = "https://github.com/haskell-gi/gi-gtk-hs";
  description = "A wrapper for gi-gtk, adding a few more idiomatic API parts on top";
  license = stdenv.lib.licenses.lgpl21;
}
