{ mkDerivation
, aeson
, base
, bytestring
, Cabal
, containers
, directory
, file-embed
, filepath
, haskell-src-exts
, HsYAML
, HsYAML-aeson
, HUnit
, mtl
, optparse-applicative
, random
, semigroups
, stdenv
, strict
, syb
, test-framework
, test-framework-hunit
, text
}:
mkDerivation {
  pname = "stylish-haskell";
  version = "0.11.0.3";
  sha256 = "7645e72d415e0c7626ef813a8c9e6ffb63824e5cb1d38db33931d99270a15b83";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    directory
    file-embed
    filepath
    haskell-src-exts
    HsYAML
    HsYAML-aeson
    mtl
    semigroups
    syb
    text
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    directory
    file-embed
    filepath
    haskell-src-exts
    HsYAML
    HsYAML-aeson
    mtl
    optparse-applicative
    strict
    syb
  ];
  testHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    directory
    file-embed
    filepath
    haskell-src-exts
    HsYAML
    HsYAML-aeson
    HUnit
    mtl
    random
    syb
    test-framework
    test-framework-hunit
    text
  ];
  jailbreak = true;
  homepage = "https://github.com/jaspervdj/stylish-haskell";
  description = "Haskell code prettifier";
  license = stdenv.lib.licenses.bsd3;
}
