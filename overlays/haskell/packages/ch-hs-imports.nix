{ mkDerivation, abstract-par, base, containers, deepseq, directory
, dlist, fetchgit, filepath, lib, megaparsec, monad-par
, monad-par-extras, monoidal-containers, mtl, nonempty-containers
, optparse-applicative, process, text, transformers
}:
mkDerivation {
  pname = "ch-hs-imports";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/circuithub/ch-hs-imports";
    sha256 = "1a68w5g95h7ry1w4jwdpjz3ky8i9nqmqm6gq73rqc9jp550lsibs";
    rev = "417d404a7e8e4e6e5544cb497c7787efe1a85c36";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    abstract-par base containers deepseq directory dlist filepath
    megaparsec monad-par monad-par-extras monoidal-containers mtl
    nonempty-containers optparse-applicative process text transformers
  ];
  license = lib.licenses.mit;
}
