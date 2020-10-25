{ mkDerivation
, aeson
, base
, bytestring
, directory
, doctest
, edit-distance-vector
, filepath
, Glob
, hashable
, mtl
, optparse-applicative
, QuickCheck
, quickcheck-instances
, scientific
, stdenv
, text
, unordered-containers
, vector
}:
mkDerivation {
  pname = "aeson-diff";
  version = "1.1.0.9";
  sha256 = "22654e736744e34e729664614605cc0f9b0fa2dac013d69bc9f971293d2675a1";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    edit-distance-vector
    hashable
    mtl
    scientific
    text
    unordered-containers
    vector
  ];
  executableHaskellDepends = [
    aeson
    base
    bytestring
    optparse-applicative
    text
  ];
  testHaskellDepends = [
    aeson
    base
    bytestring
    directory
    doctest
    filepath
    Glob
    QuickCheck
    quickcheck-instances
    text
    unordered-containers
    vector
  ];
  homepage = "https://github.com/thsutton/aeson-diff";
  description = "Extract and apply patches to JSON documents";
  license = stdenv.lib.licenses.bsd3;
}
