{ mkDerivation, base, base-compat, base-orphans, deepseq, HUnit
, QuickCheck, stdenv, tagged, tasty, tasty-hunit, tasty-quickcheck
, time
}:
mkDerivation {
  pname = "time-compat";
  version = "1.9.2.2";
  sha256 = "a268613385d359274edf48fb2dad4af29874f58486b2d5625e3b95a371066a17";
  revision = "1";
  editedCabalFile = "0k8ph4sydaiqp8dav4if6hpiaq8h1xsr93khmdr7a1mmfwdxr64r";
  libraryHaskellDepends = [ base base-orphans deepseq time ];
  testHaskellDepends = [
    base base-compat deepseq HUnit QuickCheck tagged tasty tasty-hunit
    tasty-quickcheck time
  ];
  doCheck = false;
  homepage = "https://github.com/phadej/time-compat";
  description = "Compatibility package for time";
  license = stdenv.lib.licenses.bsd3;
}
