{ mkDerivation
, base
, containers
, hspec
, HUnit
, mtl
, stdenv
, syb
, template-haskell
, th-expand-syns
, th-lift
, th-orphans
}:
mkDerivation {
  pname = "th-desugar";
  version = "1.6";
  sha256 = "c8f8ece2bde9b12070ea50bc089fbc672f144659225d837478fbc793777f634f";
  revision = "2";
  editedCabalFile = "0rimjzkqky6sq4yba7vqra7hj29903f9xsn2g8rc23abrm35vds3";
  libraryHaskellDepends = [
    base
    containers
    mtl
    syb
    template-haskell
    th-expand-syns
    th-lift
    th-orphans
  ];
  testHaskellDepends = [
    base
    containers
    hspec
    HUnit
    mtl
    syb
    template-haskell
    th-expand-syns
    th-lift
    th-orphans
  ];
  homepage = "https://github.com/goldfirere/th-desugar";
  description = "Functions to desugar Template Haskell";
  license = stdenv.lib.licenses.bsd3;
}
