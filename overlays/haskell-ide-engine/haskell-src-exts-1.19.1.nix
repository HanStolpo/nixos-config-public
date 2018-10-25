{ mkDerivation, array, base, containers, cpphs, directory, filepath
, ghc-prim, happy, mtl, pretty, pretty-show, smallcheck, stdenv
, tasty, tasty-golden, tasty-smallcheck
}:
mkDerivation {
  pname = "haskell-src-exts";
  version = "1.19.1";
  sha256 = "f0f5b2867673d654c7cce8a5fcc69222ea09af460c29a819c23cccf6311ba971";
  libraryHaskellDepends = [ array base cpphs ghc-prim pretty ];
  libraryToolDepends = [ happy ];
  testHaskellDepends = [
    base containers directory filepath mtl pretty-show smallcheck tasty
    tasty-golden tasty-smallcheck
  ];
  doCheck = false;
  homepage = "https://github.com/haskell-suite/haskell-src-exts";
  description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  license = stdenv.lib.licenses.bsd3;
}
