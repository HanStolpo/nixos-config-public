{ mkDerivation, base, clock, directory, filepath, process
, QuickCheck, quickcheck-instances, stdenv, time, unix
}:
mkDerivation {
  pname = "extra";
  version = "1.7.3";
  sha256 = "ca1a3930fa8f28acaec5a2a7657f5249310a2973bd056c8fcbe28ff98d27bca5";
  libraryHaskellDepends = [
    base clock directory filepath process time unix
  ];
  testHaskellDepends = [
    base directory filepath QuickCheck quickcheck-instances unix
  ];
  homepage = "https://github.com/ndmitchell/extra#readme";
  description = "Extra functions I use";
  license = stdenv.lib.licenses.bsd3;
}
