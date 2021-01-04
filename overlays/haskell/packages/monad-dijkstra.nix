{ mkDerivation
, base
, containers
, free
, hlint
, mtl
, psqueues
, stdenv
, tasty
, tasty-hspec
, transformers
}:
mkDerivation {
  pname = "monad-dijkstra";
  version = "0.1.1.3";
  sha256 = "6c6270f94d27203b6974563398e4b7e81ae53e6110cffaecf8ff6297c11ceb8f";
  libraryHaskellDepends = [
    base
    containers
    free
    mtl
    psqueues
    transformers
  ];
  testHaskellDepends = [ base hlint tasty tasty-hspec ];
  homepage = "https://github.com/ennocramer/monad-dijkstra";
  description = "A monad transformer for weighted graph searches";
  license = stdenv.lib.licenses.bsd3;
}
