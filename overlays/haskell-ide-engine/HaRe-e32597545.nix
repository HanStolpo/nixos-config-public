{ mkDerivation
, attoparsec
, base
, base-prelude
, Cabal
, cabal-helper
, case-insensitive
, containers
, conversion
, conversion-case-insensitive
, conversion-text
, Diff
, directory
, fetchgit
, filepath
, foldl
, ghc
, ghc-exactprint
, ghc-mod-core
, ghc-syb-utils
, gitrev
, hslogger
, hspec
, HUnit
, monad-control
, mtl
, optparse-applicative
, optparse-simple
, parsec
, stdenv
, Strafunski-StrategyLib
, syb
, syz
, turtle
}:
mkDerivation {
  pname = "HaRe";
  version = "0.8.4.1";
  src = fetchgit {
    url = "https://gitlab.com/alanz/HaRe.git";
    sha256 = "0z7r3l4j5a1brz7zb2rgd985m58rs0ki2p59y1l9i46fcy8r9y4g";
    rev = "e325975450ce89d790ed3f92de3ef675967d9538";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base
    cabal-helper
    containers
    directory
    filepath
    ghc
    ghc-exactprint
    ghc-mod-core
    ghc-syb-utils
    hslogger
    monad-control
    mtl
    Strafunski-StrategyLib
    syb
    syz
  ];
  executableHaskellDepends = [
    base
    Cabal
    ghc-mod-core
    gitrev
    mtl
    optparse-applicative
    optparse-simple
  ];
  testHaskellDepends = [
    attoparsec
    base
    base-prelude
    cabal-helper
    case-insensitive
    containers
    conversion
    conversion-case-insensitive
    conversion-text
    Diff
    directory
    filepath
    foldl
    ghc
    ghc-exactprint
    ghc-mod-core
    ghc-syb-utils
    hslogger
    hspec
    HUnit
    monad-control
    mtl
    parsec
    Strafunski-StrategyLib
    syb
    syz
    turtle
  ];
  homepage = "https://github.com/RefactoringTools/HaRe/wiki";
  description = "the Haskell Refactorer";
  license = stdenv.lib.licenses.bsd3;
}
