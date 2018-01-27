{ mkDerivation, aeson, base, containers, directory, either
, fetchgit, filepath, ghc, ghc-exactprint, ghc-mod, ghc-mod-core
, haddock-api, haddock-library, HaRe, haskell-lsp, hie-base
, hie-ghc-mod, hie-hare, hie-plugin-api, lens, monad-control, mtl
, stdenv, text, transformers
}:
mkDerivation {
  pname = "hie-haddock";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix {inherit fetchgit;};
  postUnpack = "sourceRoot+=/hie-haddock; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers directory either filepath ghc ghc-exactprint
    ghc-mod ghc-mod-core haddock-api haddock-library HaRe haskell-lsp
    hie-base hie-ghc-mod hie-hare hie-plugin-api lens monad-control mtl
    text transformers
  ];
  description = "Haskell IDE Haddock plugin";
  license = stdenv.lib.licenses.bsd3;
}
