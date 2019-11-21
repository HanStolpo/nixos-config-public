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
    sha256 = "06240cpqbbbq1z677qphdjz2r01dazxzw8c8xicwzbl5h4v0xxyd";
    rev = "4c48e06047d0acc2ea0bd4e6afdc7e6701b1d8f4";
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
