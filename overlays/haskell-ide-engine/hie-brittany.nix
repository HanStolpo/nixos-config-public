{ mkDerivation
, aeson
, base
, brittany
, fetchgit
, ghc-mod
, ghc-mod-core
, haskell-lsp
, hie-plugin-api
, lens
, stdenv
, text
}:
mkDerivation {
  pname = "hie-brittany";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix { inherit fetchgit; };
  postUnpack = "sourceRoot+=/hie-brittany; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson
    base
    brittany
    ghc-mod
    ghc-mod-core
    haskell-lsp
    hie-plugin-api
    lens
    text
  ];
  description = "Haskell IDE Hoogle plugin";
  license = stdenv.lib.licenses.bsd3;
}
