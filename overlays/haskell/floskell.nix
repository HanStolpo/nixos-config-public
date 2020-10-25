{ mkDerivation
, aeson
, aeson-pretty
, attoparsec
, base
, bytestring
, containers
, criterion
, data-default
, deepseq
, directory
, exceptions
, filepath
, ghc-prim
, haskell-src-exts
, hspec
, monad-dijkstra
, mtl
, optparse-applicative
, stdenv
, text
, transformers
, unordered-containers
, utf8-string
}:
mkDerivation {
  pname = "floskell";
  version = "0.10.4";
  sha256 = "a684cea04f42bc8048396cbbec5596ee9b2f4f0826ca6b67dc4c6cdf855f9c91";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson
    attoparsec
    base
    bytestring
    containers
    data-default
    directory
    filepath
    haskell-src-exts
    monad-dijkstra
    mtl
    text
    transformers
    unordered-containers
    utf8-string
  ];
  executableHaskellDepends = [
    aeson-pretty
    base
    bytestring
    directory
    ghc-prim
    haskell-src-exts
    optparse-applicative
    text
  ];
  testHaskellDepends = [
    base
    bytestring
    deepseq
    exceptions
    haskell-src-exts
    hspec
    text
    utf8-string
  ];
  benchmarkHaskellDepends = [
    base
    bytestring
    criterion
    deepseq
    exceptions
    ghc-prim
    haskell-src-exts
    text
    utf8-string
  ];
  doCheck = false;
  homepage = "https://github.com/ennocramer/floskell";
  description = "A flexible Haskell source code pretty printer";
  license = stdenv.lib.licenses.bsd3;
}
