{ mkDerivation
, aeson
, base
, bifunctors
, bytestring
, Cabal
, containers
, cryptonite
, deepseq
, directory
, filepath
, Glob
, hspec
, hspec-discover
, http-client
, http-client-tls
, http-types
, HUnit
, infer-license
, interpolate
, mockery
, pretty
, QuickCheck
, scientific
, stdenv
, template-haskell
, temporary
, text
, transformers
, unordered-containers
, vector
, yaml
}:
mkDerivation {
  pname = "hpack";
  version = "0.31.1";
  sha256 = "ac3ab2b42339f6e3d45b89e4ee9acf33550f7fac6518b8cf47a874226b5d373a";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bifunctors
    bytestring
    Cabal
    containers
    cryptonite
    deepseq
    directory
    filepath
    Glob
    http-client
    http-client-tls
    http-types
    infer-license
    pretty
    scientific
    text
    transformers
    unordered-containers
    vector
    yaml
  ];
  executableHaskellDepends = [
    aeson
    base
    bifunctors
    bytestring
    Cabal
    containers
    cryptonite
    deepseq
    directory
    filepath
    Glob
    http-client
    http-client-tls
    http-types
    infer-license
    pretty
    scientific
    text
    transformers
    unordered-containers
    vector
    yaml
  ];
  testHaskellDepends = [
    aeson
    base
    bifunctors
    bytestring
    Cabal
    containers
    cryptonite
    deepseq
    directory
    filepath
    Glob
    hspec
    http-client
    http-client-tls
    http-types
    HUnit
    infer-license
    interpolate
    mockery
    pretty
    QuickCheck
    scientific
    template-haskell
    temporary
    text
    transformers
    unordered-containers
    vector
    yaml
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/sol/hpack#readme";
  description = "A modern format for Haskell packages";
  license = stdenv.lib.licenses.mit;
}
