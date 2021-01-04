{ mkDerivation
, base
, bytestring
, containers
, Diff
, directory
, filemanip
, filepath
, free
, ghc
, ghc-boot
, ghc-paths
, HUnit
, mtl
, silently
, stdenv
, syb
}:
mkDerivation {
  pname = "ghc-exactprint";
  version = "0.6.3.1";
  sha256 = "2d835ebd5723ec5ffc937729b2a555d628249adbeaf272f8064493fb7dac2e9b";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    bytestring
    containers
    directory
    filepath
    free
    ghc
    ghc-boot
    ghc-paths
    mtl
    syb
  ];
  testHaskellDepends = [
    base
    bytestring
    containers
    Diff
    directory
    filemanip
    filepath
    ghc
    ghc-boot
    ghc-paths
    HUnit
    mtl
    silently
    syb
  ];
  description = "ExactPrint for GHC";
  license = stdenv.lib.licenses.bsd3;
}
