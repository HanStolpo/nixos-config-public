{ mkDerivation
, base
, checkers
, exceptions
, hspec
, logict
, mmorph
, mtl
, QuickCheck
, stdenv
}:
mkDerivation {
  pname = "refinery";
  version = "0.2.0.0";
  sha256 = "988f39852c04fc0211651efd57907cd915c591057b0038a0551078e4cbaa4e5b";
  libraryHaskellDepends = [ base exceptions logict mmorph mtl ];
  testHaskellDepends = [
    base
    checkers
    exceptions
    hspec
    logict
    mmorph
    mtl
    QuickCheck
  ];
  doCheck = false;
  homepage = "https://github.com/totbwf/refinery#readme";
  description = "Toolkit for building proof automation systems";
  license = stdenv.lib.licenses.bsd3;
}
