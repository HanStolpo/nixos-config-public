{ mkDerivation
, base
, Cabal
, containers
, directory
, filepath
, mtl
, process
, stdenv
, syb
, tasty
, tasty-golden
, template-haskell
, th-desugar
}:
mkDerivation {
  pname = "singletons";
  version = "2.2";
  sha256 = "1bwcsp1x8bivmvkv8a724lsnwyjharhb0x0hl0isp3jgigh0dg9k";
  libraryHaskellDepends = [
    base
    containers
    mtl
    syb
    template-haskell
    th-desugar
  ];
  testHaskellDepends = [
    base
    Cabal
    directory
    filepath
    process
    tasty
    tasty-golden
  ];
  homepage = "http://www.github.com/goldfirere/singletons";
  description = "A framework for generating singleton types";
  license = stdenv.lib.licenses.bsd3;
}
