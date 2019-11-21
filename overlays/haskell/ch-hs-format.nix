{ mkDerivation, base, containers, fetchgit, ghc, ghc-exactprint
, optparse-applicative, stdenv
}:
mkDerivation {
  pname = "ch-hs-format";
  version = "1.0.0";
  src = fetchgit {
    url = "https://github.com/circuithub/ch-hs-format";
    sha256 = "00kgp7fv9lm1n5xczshdhc6s2rnf722b7kp03qwzb1s9afd1z01d";
    rev = "d9fc4ac56d6c68076097ea4d0760e0f89ccd5e82";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base containers ghc ghc-exactprint optparse-applicative
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
