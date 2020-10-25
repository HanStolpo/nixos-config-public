{ mkDerivation
, base
, containers
, directory
, filepath
, ghc
, ghc-paths
, process
, safe-exceptions
, stdenv
, template-haskell
, transformers
}:
mkDerivation {
  pname = "ghc-check";
  version = "0.5.0.1";
  sha256 = "08a0acdf12869e146751556aaca8d82cc355de41910c9e4c9cc1b527ee93e723";
  libraryHaskellDepends = [
    base
    containers
    directory
    filepath
    ghc
    ghc-paths
    process
    safe-exceptions
    template-haskell
    transformers
  ];
  description = "detect mismatches between compile-time and run-time versions of the ghc api";
  license = stdenv.lib.licenses.bsd3;
}
