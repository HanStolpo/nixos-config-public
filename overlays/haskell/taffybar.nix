{ mkDerivation, base, bytestring, ConfigFile, containers, dbus
, dbus-hslogger, directory, dyre, either, enclosed-exceptions
, fetchgit, filepath, gi-cairo, gi-cairo-connector, gi-cairo-render
, gi-gdk, gi-gdkpixbuf, gi-gdkx11, gi-glib, gi-gtk, gi-gtk-hs
, gi-pango, gtk-sni-tray, gtk-strut, gtk3, haskell-gi
, haskell-gi-base, hslogger, HStringTemplate, HTTP, multimap
, network, network-uri, old-locale, optparse-applicative, parsec
, process, rate-limit, regex-compat, safe, scotty, split
, status-notifier-item, stdenv, stm, template-haskell, text, time
, time-locale-compat, time-units, transformers, transformers-base
, tuple, unix, utf8-string, X11, xdg-basedir, xml, xml-helpers
, xmonad
}:
mkDerivation {
  pname = "taffybar";
  version = "3.1.1";
  src = fetchgit {
    url = "https://github.com/taffybar/taffybar";
    sha256 = "0qncwpfz0v2b6nbdf7qgzl93kb30yxznkfk49awrz8ms3pq6vq6g";
    rev = "e382599358bb06383ba4b08d469fc093c11f5915";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base bytestring ConfigFile containers dbus dbus-hslogger directory
    dyre either enclosed-exceptions filepath gi-cairo
    gi-cairo-connector gi-cairo-render gi-gdk gi-gdkpixbuf gi-gdkx11
    gi-glib gi-gtk gi-gtk-hs gi-pango gtk-sni-tray gtk-strut haskell-gi
    haskell-gi-base hslogger HStringTemplate HTTP multimap network
    network-uri old-locale parsec process rate-limit regex-compat safe
    scotty split status-notifier-item stm template-haskell text time
    time-locale-compat time-units transformers transformers-base tuple
    unix utf8-string X11 xdg-basedir xml xml-helpers xmonad
  ];
  libraryPkgconfigDepends = [ gtk3 ];
  executableHaskellDepends = [ base hslogger optparse-applicative ];
  executablePkgconfigDepends = [ gtk3 ];
  homepage = "http://github.com/taffybar/taffybar";
  description = "A desktop bar similar to xmobar, but with more GUI";
  license = stdenv.lib.licenses.bsd3;
}
