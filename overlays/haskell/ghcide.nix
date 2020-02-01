{ mkDerivation
, aeson
, async
, base
, binary
, bytestring
, containers
, data-default
, deepseq
, directory
, extra
, fetchgit
, filepath
, fuzzy
, ghc
, ghc-boot
, ghc-boot-th
, ghc-paths
, ghc-typelits-knownnat
, gitrev
, haddock-library
, hashable
, haskell-lsp
, haskell-lsp-types
, hie-bios
, hslogger
, lens
, lsp-test
, mtl
, network-uri
, optparse-applicative
, parser-combinators
, prettyprinter
, prettyprinter-ansi-terminal
, QuickCheck
, quickcheck-instances
, regex-tdfa
, rope-utf16-splay
, safe-exceptions
, shake
, sorted-list
, stdenv
, stm
, syb
, tasty
, tasty-expected-failure
, tasty-hunit
, tasty-quickcheck
, text
, time
, transformers
, unix
, unordered-containers
, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.0.6";
  src = fetchgit {
    url = "git://github.com/digital-asset/ghcide";
    sha256 = "0vwydqb3b76ksw54van21vla2k81x1sy4mkz6jx9z0p62kr8xqcg";
    rev = "913aa5f9fa3508dcbe423aea3e0d0effe1b57d1b";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    async
    base
    binary
    bytestring
    containers
    data-default
    deepseq
    directory
    extra
    filepath
    fuzzy
    ghc
    ghc-boot
    ghc-boot-th
    haddock-library
    hashable
    haskell-lsp
    haskell-lsp-types
    hslogger
    mtl
    network-uri
    prettyprinter
    prettyprinter-ansi-terminal
    regex-tdfa
    rope-utf16-splay
    safe-exceptions
    shake
    sorted-list
    stm
    syb
    text
    time
    transformers
    unix
    unordered-containers
    utf8-string
  ];
  executableHaskellDepends = [
    base
    containers
    data-default
    directory
    extra
    filepath
    ghc
    ghc-paths
    gitrev
    haskell-lsp
    hie-bios
    hslogger
    optparse-applicative
    shake
    text
  ];
  testHaskellDepends = [
    aeson
    base
    bytestring
    containers
    directory
    extra
    filepath
    ghc
    ghc-typelits-knownnat
    haddock-library
    haskell-lsp
    haskell-lsp-types
    lens
    lsp-test
    parser-combinators
    QuickCheck
    quickcheck-instances
    rope-utf16-splay
    tasty
    tasty-expected-failure
    tasty-hunit
    tasty-quickcheck
    text
  ];
  doCheck = false;
  homepage = "https://github.com/digital-asset/ghcide#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
