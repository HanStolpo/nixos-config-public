{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, bytestring
, containers, hostname, HUnit, libxml, old-locale, QuickCheck
, random, regex-posix, semigroups, stdenv, time, xml
}:
mkDerivation {
  pname = "test-framework";
  version = "0.8.2.0";
  sha256 = "f5aec7a15dbcb39e951bcf6502606fd99d751197b5510f41706899aa7e660ac2";
  revision = "5";
  editedCabalFile = "18g92ajx3ghznd6k3ihj22ln29n676ailzwx3k0f1kj3bmpilnh6";
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint base containers hostname old-locale
    random regex-posix time xml
  ];
  testHaskellDepends = [
    ansi-terminal ansi-wl-pprint base bytestring containers hostname
    HUnit libxml old-locale QuickCheck random regex-posix semigroups
    time xml
  ];
  homepage = "http://haskell.github.io/test-framework/";
  description = "Framework for running and organising tests, with HUnit and QuickCheck support";
  license = stdenv.lib.licenses.bsd3;
}
