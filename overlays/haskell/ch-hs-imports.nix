{ mkDerivation
, abstract-par
, base
, containers
, deepseq
, directory
, dlist
, fetchgit
, filepath
, megaparsec
, monad-par
, monad-par-extras
, monoidal-containers
, mtl
, nonempty-containers
, optparse-applicative
, process
, stdenv
, text
, transformers
}:
mkDerivation {
  pname = "ch-hs-imports";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/circuithub/ch-hs-imports";
    sha256 = "0bfzck2fhfv65cdnphjihbp54y8xaklwcc2dl47h7xpvwq61p1m9";
    rev = "7d11ee89b0731f43a2d3248b8e339f8b55a3e2d2";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    abstract-par
    base
    containers
    deepseq
    directory
    dlist
    filepath
    megaparsec
    monad-par
    monad-par-extras
    monoidal-containers
    mtl
    nonempty-containers
    optparse-applicative
    process
    text
    transformers
  ];
  license = stdenv.lib.licenses.mit;
}
