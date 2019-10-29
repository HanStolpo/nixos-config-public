{ mkDerivation, aeson, aeson-pretty, ansi-terminal, async, base
, bytestring, conduit, conduit-parse, containers, data-default
, Diff, directory, fetchgit, filepath, haskell-lsp, hspec, lens
, mtl, parser-combinators, process, rope-utf16-splay, stdenv, text
, transformers, unix, unordered-containers
}:
mkDerivation {
  pname = "lsp-test";
  version = "0.8.0.0";
  src = fetchgit {
    url = "https://github.com/bubba/lsp-test";
    sha256 = "0nadsjkfwdqg0q7ypy7w5kv97hgr1ycwh9ii3azcf7vq7nnmjnw6";
    rev = "c80fbbc91756f4fea141f434f251d7ff7c0e4596";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal async base bytestring conduit
    conduit-parse containers data-default Diff directory filepath
    haskell-lsp lens mtl parser-combinators process rope-utf16-splay
    text transformers unix unordered-containers
  ];
  testHaskellDepends = [
    aeson base data-default haskell-lsp hspec lens text
    unordered-containers
  ];
  doCheck = false;
  homepage = "https://github.com/bubba/lsp-test#readme";
  description = "Functional test framework for LSP servers";
  license = stdenv.lib.licenses.bsd3;
}
