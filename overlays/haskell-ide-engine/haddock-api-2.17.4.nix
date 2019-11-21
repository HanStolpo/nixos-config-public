{ mkDerivation
, array
, base
, bytestring
, Cabal
, containers
, deepseq
, directory
, filepath
, ghc
, ghc-boot
, ghc-paths
, haddock-library
, hspec
, QuickCheck
, stdenv
, transformers
, xhtml
}:
mkDerivation {
  pname = "haddock-api";
  version = "2.17.4";
  sha256 = "5a97114f567bb7384d07dfc77a7c2f6c35017193e63411b85ab2a3f7fe35d601";
  revision = "1";
  editedCabalFile = "0saa5ksmvxyvwi2nrzh7m4ha1kwh31pkpa79yrppvw7sm39klpyw";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    array
    base
    bytestring
    Cabal
    containers
    deepseq
    directory
    filepath
    ghc
    ghc-boot
    ghc-paths
    haddock-library
    transformers
    xhtml
  ];
  testHaskellDepends = [ base containers ghc hspec QuickCheck ];
  homepage = "http://www.haskell.org/haddock/";
  description = "A documentation-generation tool for Haskell libraries";
  license = stdenv.lib.licenses.bsd3;
}
