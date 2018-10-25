{ mkDerivation, base, base-compat, bytestring, deepseq, hspec
, QuickCheck, stdenv, transformers
}:
mkDerivation {
  pname = "haddock-library";
  version = "1.4.3";
  sha256 = "f764763f8004715431a184a981493781b8380e13fd89ca0075ac426edc5d445b";
  libraryHaskellDepends = [ base bytestring deepseq transformers ];
  testHaskellDepends = [
    base base-compat bytestring deepseq hspec QuickCheck transformers
  ];
  homepage = "http://www.haskell.org/haddock/";
  description = "Library exposing some functionality of Haddock";
  license = stdenv.lib.licenses.bsd3;
}
