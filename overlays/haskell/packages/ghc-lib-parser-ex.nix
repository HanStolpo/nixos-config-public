{ mkDerivation, base, bytestring, containers, directory, extra
, filepath, ghc-lib-parser, stdenv, tasty, tasty-hunit, uniplate
}:
mkDerivation {
  pname = "ghc-lib-parser-ex";
  version = "8.10.0.13";
  sha256 = "5fda3e2e0d2f2857e7b6a6aa8f7956fdccec413bcea55a56192b0ec72bab2cdf";
  libraryHaskellDepends = [
    base bytestring containers ghc-lib-parser uniplate
  ];
  testHaskellDepends = [
    base directory extra filepath ghc-lib-parser tasty tasty-hunit
  ];
  homepage = "https://github.com/shayne-fletcher/ghc-lib-parser-ex#readme";
  description = "Algorithms on GHC parse trees";
  license = stdenv.lib.licenses.bsd3;
}
