{ mkDerivation
, base
, bytestring
, containers
, dlist
, exceptions
, fetchgit
, filepath
, ghc
, ghc-boot-th
, ghc-paths
, gitrev
, hspec
, hspec-discover
, mtl
, optparse-applicative
, path
, path-io
, stdenv
, syb
, text
}:
mkDerivation {
  pname = "ormolu";
  version = "0.0.1.0";
  src = fetchgit {
    url = "https://github.com/tweag/ormolu";
    sha256 = "0vqrb12bsp1dczff3i5pajzhjwz035rxg8vznrgj5p6j7mb2vcnd";
    rev = "3abadaefa5e190ff346f9aeb309465ac890495c2";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base
    bytestring
    containers
    dlist
    exceptions
    ghc
    ghc-boot-th
    ghc-paths
    mtl
    syb
    text
  ];
  executableHaskellDepends = [
    base
    ghc
    gitrev
    optparse-applicative
    text
  ];
  testHaskellDepends = [
    base
    containers
    filepath
    hspec
    path
    path-io
    text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/tweag/ormolu";
  description = "A formatter for Haskell source code";
  license = stdenv.lib.licenses.bsd3;
}
