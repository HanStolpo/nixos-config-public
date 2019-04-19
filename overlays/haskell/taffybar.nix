{ mkDerivation, base, broadcast-chan, bytestring, ConfigFile
, containers, dbus, dbus-hslogger, directory, dyre, either
, enclosed-exceptions, fetchgit, filepath, gi-cairo
, gi-cairo-connector, gi-cairo-render, gi-gdk, gi-gdkpixbuf
, gi-gdkx11, gi-glib, gi-gtk, gi-gtk-hs, gi-pango, gtk-sni-tray
, gtk-strut, gtk3, haskell-gi, haskell-gi-base, hslogger
, HStringTemplate, http-client, http-client-tls, http-types
, multimap, network, network-uri, old-locale, optparse-applicative
, parsec, process, rate-limit, regex-compat, safe, scotty, split
, status-notifier-item, stdenv, stm, template-haskell, text, time
, time-locale-compat, time-units, transformers, transformers-base
, tuple, unix, utf8-string, X11, xdg-basedir, xml, xml-helpers
, xmonad
}:
mkDerivation {
  pname = "taffybar";
  version = "3.1.2";
  src = fetchgit {
    url = "https://github.com/taffybar/taffybar";
    sha256 = "1ay63pp5s8jlgnfm4l7lhj1qk862dwz9gh0n4dk4w0yygha8phw7";
    rev = "d4f983fe3f6ab1278aed1cc884b5afbcf1f4415d";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base broadcast-chan bytestring ConfigFile containers dbus
    dbus-hslogger directory dyre either enclosed-exceptions filepath
    gi-cairo gi-cairo-connector gi-cairo-render gi-gdk gi-gdkpixbuf
    gi-gdkx11 gi-glib gi-gtk gi-gtk-hs gi-pango gtk-sni-tray gtk-strut
    haskell-gi haskell-gi-base hslogger HStringTemplate http-client
    http-client-tls http-types multimap network network-uri old-locale
    parsec process rate-limit regex-compat safe scotty split
    status-notifier-item stm template-haskell text time
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
