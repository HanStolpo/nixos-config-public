{ mkDerivation
, base
, containers
, fetchgit
, ghc
, ghc-exactprint
, optparse-applicative
, stdenv
}:
mkDerivation {
  pname = "ch-hs-format";
  version = "1.0.0";
  src = fetchgit {
    url = "git://github.com/circuithub/ch-hs-format";
    sha256 = "1njl5xvmvzkigvnz37yd6gpvwyrbkj15mkqarypccf7yakxwqk8s";
    rev = "aeffb3a87dc53b37647ba7054c7eca195e088b3d";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    containers
    ghc
    ghc-exactprint
    optparse-applicative
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
