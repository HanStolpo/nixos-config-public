{ mkDerivation
, base
, bytestring
, containers
, dlist
, exceptions
, filepath
, ghc-lib-parser
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
  version = "0.1.2.0";
  sha256 = "179fc3d67d9376ea373eb6dd92716936bdbd9806edc482470bc783be98c3cd92";
  revision = "2";
  editedCabalFile = "07p7342972b2ffi46ll8jgbnlx97g7imzpl819hzc0yd2pjn4jn9";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base
    bytestring
    containers
    dlist
    exceptions
    ghc-lib-parser
    mtl
    syb
    text
  ];
  executableHaskellDepends = [
    base
    ghc-lib-parser
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
