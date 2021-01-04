{ mkDerivation
, ansi-terminal
, async
, base
, bytestring
, containers
, data-default
, deepseq
, directory
, filepath
, ghc
, ghc-exactprint
, ghc-paths
, haskell-src-exts
, HUnit
, mtl
, optparse-applicative
, process
, random-shuffle
, stdenv
, syb
, tasty
, tasty-hunit
, temporary
, text
, transformers
, unordered-containers
}:
mkDerivation {
  pname = "retrie";
  version = "0.1.1.1";
  sha256 = "f162028ecbfea991f8a22701637b3869c8bd306f48823316c92496e4ea66d7d0";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal
    async
    base
    bytestring
    containers
    data-default
    directory
    filepath
    ghc
    ghc-exactprint
    mtl
    optparse-applicative
    process
    random-shuffle
    syb
    text
    transformers
    unordered-containers
  ];
  executableHaskellDepends = [ base haskell-src-exts ];
  testHaskellDepends = [
    base
    containers
    data-default
    deepseq
    directory
    filepath
    ghc
    ghc-paths
    haskell-src-exts
    HUnit
    mtl
    optparse-applicative
    process
    syb
    tasty
    tasty-hunit
    temporary
    text
    unordered-containers
  ];
  jailbreak = true;
  doCheck = false;
  homepage = "https://github.com/facebookincubator/retrie";
  description = "A powerful, easy-to-use codemodding tool for Haskell";
  license = stdenv.lib.licenses.mit;
}
