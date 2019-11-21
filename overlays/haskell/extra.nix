{ mkDerivation
, base
, clock
, directory
, filepath
, process
, QuickCheck
, semigroups
, stdenv
, time
, unix
}:
mkDerivation {
  pname = "extra";
  version = "1.6.18";
  sha256 = "9e81788ea870cc94e0cd809f3258aec0a361981783f59b122aeea20801256d4b";
  libraryHaskellDepends = [
    base
    clock
    directory
    filepath
    process
    semigroups
    time
    unix
  ];
  testHaskellDepends = [ base directory filepath QuickCheck unix ];
  homepage = "https://github.com/ndmitchell/extra#readme";
  description = "Extra functions I use";
  license = stdenv.lib.licenses.bsd3;
}
