{ mkDerivation, aeson, async, base, binary, bytestring, containers
, data-default, deepseq, directory, extra, fetchgit, filepath, ghc
, ghc-boot, ghc-boot-th, ghc-paths, hashable, haskell-lsp
, haskell-lsp-types, hie-bios, lens, lsp-test, mtl, network-uri
, optparse-applicative, parser-combinators, prettyprinter
, prettyprinter-ansi-terminal, rope-utf16-splay, safe-exceptions
, shake, sorted-list, stdenv, stm, syb, tasty, tasty-hunit, text
, time, transformers, unix, unordered-containers, utf8-string
}:
mkDerivation {
  pname = "ghcide";
  version = "0.0.1";
  src = fetchgit {
    url = "git://github.com/digital-asset/daml";
    sha256 = "1f4ml9nr37s58cm4ciryq2i38sz04b37ry95qk81gw7nc8c12721";
    rev = "5b6a8094333c78a37b519c24771719f9d82e4107";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/compiler/ghcide; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers data-default deepseq
    directory extra filepath ghc ghc-boot ghc-boot-th hashable
    haskell-lsp haskell-lsp-types mtl network-uri prettyprinter
    prettyprinter-ansi-terminal rope-utf16-splay safe-exceptions shake
    sorted-list stm syb text time transformers unix
    unordered-containers utf8-string
  ];
  executableHaskellDepends = [
    base containers data-default directory extra filepath ghc ghc-paths
    haskell-lsp hie-bios optparse-applicative shake text
  ];
  testHaskellDepends = [
    base containers extra filepath haskell-lsp-types lens lsp-test
    parser-combinators tasty tasty-hunit text
  ];
  doCheck = false;
  homepage = "https://github.com/digital-asset/daml#readme";
  description = "The core of an IDE";
  license = stdenv.lib.licenses.asl20;
}
