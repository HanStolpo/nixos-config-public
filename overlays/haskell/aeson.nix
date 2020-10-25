{ mkDerivation
, attoparsec
, base
, base-compat
, base-compat-batteries
, base-orphans
, base16-bytestring
, bytestring
, containers
, data-fix
, deepseq
, Diff
, directory
, dlist
, filepath
, generic-deriving
, ghc-prim
, hashable
, hashable-time
, integer-logarithms
, primitive
, QuickCheck
, quickcheck-instances
, scientific
, stdenv
, strict
, tagged
, tasty
, tasty-golden
, tasty-hunit
, tasty-quickcheck
, template-haskell
, text
, th-abstraction
, these
, time
, time-compat
, unordered-containers
, uuid-types
, vector
}:
mkDerivation {
  pname = "aeson";
  version = "1.5.4.0";
  sha256 = "80d0a13f952b40e5a6f118bf9a10470426446dd54dc6348b6e6cf86e22cd0f9f";
  libraryHaskellDepends = [
    attoparsec
    base
    base-compat-batteries
    bytestring
    containers
    data-fix
    deepseq
    dlist
    ghc-prim
    hashable
    primitive
    scientific
    strict
    tagged
    template-haskell
    text
    th-abstraction
    these
    time
    time-compat
    unordered-containers
    uuid-types
    vector
  ];
  testHaskellDepends = [
    attoparsec
    base
    base-compat
    base-orphans
    base16-bytestring
    bytestring
    containers
    data-fix
    Diff
    directory
    dlist
    filepath
    generic-deriving
    ghc-prim
    hashable
    hashable-time
    integer-logarithms
    QuickCheck
    quickcheck-instances
    scientific
    strict
    tagged
    tasty
    tasty-golden
    tasty-hunit
    tasty-quickcheck
    template-haskell
    text
    these
    time
    time-compat
    unordered-containers
    uuid-types
    vector
  ];
  jailbreak = true;
  doCheck = false;
  homepage = "https://github.com/bos/aeson";
  description = "Fast JSON parsing and encoding";
  license = stdenv.lib.licenses.bsd3;
}
