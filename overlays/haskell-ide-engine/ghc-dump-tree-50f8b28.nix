{ mkDerivation
, aeson
, base
, bytestring
, fetchgit
, ghc
, optparse-applicative
, pretty
, pretty-show
, process
, stdenv
, unordered-containers
, vector
}:
mkDerivation {
  pname = "ghc-dump-tree";
  version = "0.2.0.1";
  src = fetchgit {
    url = "https://github.com/edsko/ghc-dump-tree";
    sha256 = "0v3r81apdqp91sv7avy7f0s3im9icrakkggw8q5b7h0h4js6irqj";
    rev = "50f8b28fda675cca4df53909667c740120060c49";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    ghc
    pretty
    pretty-show
    process
    unordered-containers
    vector
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    ghc
    optparse-applicative
    pretty
    pretty-show
    process
    unordered-containers
    vector
  ];
  homepage = "https://github.com/edsko/ghc-dump-tree";
  description = "Dump GHC's parsed, renamed, and type checked ASTs";
  license = stdenv.lib.licenses.bsd3;
}
