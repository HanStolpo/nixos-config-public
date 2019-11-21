{ mkDerivation
, aeson
, apply-refact
, base
, either
, extra
, fetchgit
, ghc-mod
, ghc-mod-core
, haskell-src-exts
, hie-base
, hie-plugin-api
, hlint
, stdenv
, text
}:
mkDerivation {
  pname = "hie-apply-refact";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix { inherit fetchgit; };
  postUnpack = "sourceRoot+=/hie-apply-refact; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson
    apply-refact
    base
    either
    extra
    ghc-mod
    ghc-mod-core
    haskell-src-exts
    hie-base
    hie-plugin-api
    hlint
    text
  ];
  description = "Haskell IDE Apply Refact plugin";
  license = stdenv.lib.licenses.bsd3;
}
