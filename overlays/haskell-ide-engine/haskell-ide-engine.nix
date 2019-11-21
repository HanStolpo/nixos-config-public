{ mkDerivation
, aeson
, async
, base
, bytestring
, Cabal
, containers
, data-default
, Diff
, directory
, either
, fetchgit
, filepath
, ghc
, ghc-mod-core
, gitrev
, haskell-lsp
, hie-apply-refact
, hie-base
, hie-brittany
, hie-build-plugin
, hie-example-plugin2
, hie-ghc-mod
, hie-haddock
, hie-hare
, hie-hoogle
, hie-plugin-api
, hoogle
, hslogger
, hspec
, lens
, mtl
, optparse-simple
, QuickCheck
, quickcheck-instances
, sorted-list
, stdenv
, stm
, text
, time
, transformers
, unordered-containers
, vector
, vinyl
, yi-rope
, ekg
}:
mkDerivation {
  pname = "haskell-ide-engine";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix { inherit fetchgit; };
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ekg ];
  libraryHaskellDepends = [
    aeson
    async
    base
    bytestring
    Cabal
    containers
    data-default
    directory
    either
    filepath
    ghc
    ghc-mod-core
    gitrev
    haskell-lsp
    hie-apply-refact
    hie-base
    hie-brittany
    hie-ghc-mod
    hie-haddock
    hie-hare
    hie-hoogle
    hie-plugin-api
    hslogger
    lens
    mtl
    optparse-simple
    sorted-list
    stm
    text
    unordered-containers
    vector
    yi-rope
  ];
  executableHaskellDepends = [
    base
    Cabal
    containers
    directory
    ghc-mod-core
    gitrev
    haskell-lsp
    hie-apply-refact
    hie-build-plugin
    hie-example-plugin2
    hie-ghc-mod
    hie-hare
    hie-hoogle
    hie-plugin-api
    hslogger
    optparse-simple
    stm
    text
    time
    transformers
    unordered-containers
    vinyl
  ];
  testHaskellDepends = [
    aeson
    base
    containers
    Diff
    directory
    filepath
    ghc-mod-core
    haskell-lsp
    hie-apply-refact
    hie-base
    hie-example-plugin2
    hie-ghc-mod
    hie-hare
    hie-hoogle
    hie-plugin-api
    hoogle
    hslogger
    hspec
    QuickCheck
    quickcheck-instances
    stm
    text
    transformers
    unordered-containers
    vector
    vinyl
  ];
  homepage = "http://github.com/githubuser/haskell-ide-engine#readme";
  description = "Provide a common engine to power any Haskell IDE";
  license = stdenv.lib.licenses.bsd3;
}
