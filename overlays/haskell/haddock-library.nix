{ mkDerivation, base, base-compat, bytestring, containers, deepseq
, directory, filepath, hspec, hspec-discover, optparse-applicative
, parsec, QuickCheck, stdenv, text, transformers, tree-diff
}:
mkDerivation {
  pname = "haddock-library";
  version = "1.8.0";
  sha256 = "7093a70308a548c1fa46c01fe236bc27125311159ad797304e6b0ee893d8b797";
  revision = "1";
  editedCabalFile = "09v6lq3ncf3ax7b6n36vhsflm488x0qc8sgc3w17m09x1jl48d99";
  libraryHaskellDepends = [
    base bytestring containers parsec text transformers
  ];
  testHaskellDepends = [
    base base-compat bytestring containers deepseq directory filepath
    hspec optparse-applicative parsec QuickCheck text transformers
    tree-diff
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "http://www.haskell.org/haddock/";
  description = "Library exposing some functionality of Haddock";
  license = stdenv.lib.licenses.bsd2;
}
