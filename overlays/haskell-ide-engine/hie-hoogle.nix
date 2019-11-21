{ mkDerivation
, aeson
, base
, directory
, fetchgit
, filepath
, ghc-mod
, ghc-mod-core
, hie-plugin-api
, hoogle
, stdenv
, tagsoup
, text
, alex
, happy
, c2hs
, doctest
, hpc
, hsc2hs
, hscolour
, pkgconfig
}:
mkDerivation {
  pname = "hie-hoogle";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix { inherit fetchgit; };
  postUnpack = "sourceRoot+=/hie-hoogle; echo source root reset to $sourceRoot";
  buildDepends = [ alex happy c2hs doctest hpc hsc2hs hscolour pkgconfig ];
  libraryHaskellDepends = [
    aeson
    base
    directory
    filepath
    ghc-mod
    ghc-mod-core
    hie-plugin-api
    hoogle
    tagsoup
    text
  ];
  description = "Haskell IDE Hoogle plugin";
  license = stdenv.lib.licenses.bsd3;
}
