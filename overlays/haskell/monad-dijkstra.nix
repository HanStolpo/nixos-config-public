{ mkDerivation, base, containers, free, hlint, mtl, psqueues
, stdenv, tasty, tasty-hspec, transformers
}:
mkDerivation {
  pname = "monad-dijkstra";
  version = "0.1.1.2";
  sha256 = "66b5056eab091ec9cf697147c36fbda60fd7c2c8f6d4e180232a8f79bdcd20a1";
  libraryHaskellDepends = [
    base containers free mtl psqueues transformers
  ];
  testHaskellDepends = [ base hlint tasty tasty-hspec ];
  jailbreak = true;
  doCheck = false;
  homepage = "https://github.com/ennocramer/monad-dijkstra";
  description = "A monad transformer for weighted graph searches";
  license = stdenv.lib.licenses.bsd3;
}
