{ mkDerivation
, aeson
, aeson-pretty
, ansi-terminal
, async
, base
, bytestring
, conduit
, conduit-parse
, containers
, data-default
, Diff
, directory
, filepath
, Glob
, haskell-lsp
, hspec
, lens
, mtl
, parser-combinators
, process
, stdenv
, text
, transformers
, unix
, unordered-containers
}:
mkDerivation {
  pname = "lsp-test";
  version = "0.11.0.5";
  sha256 = "f05abe925537b98f2660dd37116cc6d8018736928f4ea4a19111305a4c470364";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    aeson-pretty
    ansi-terminal
    async
    base
    bytestring
    conduit
    conduit-parse
    containers
    data-default
    Diff
    directory
    filepath
    Glob
    haskell-lsp
    lens
    mtl
    parser-combinators
    process
    text
    transformers
    unix
    unordered-containers
  ];
  testHaskellDepends = [
    aeson
    base
    data-default
    directory
    filepath
    haskell-lsp
    hspec
    lens
    text
    unordered-containers
  ];
  doCheck = false;
  homepage = "https://github.com/bubba/lsp-test#readme";
  description = "Functional test framework for LSP servers";
  license = stdenv.lib.licenses.bsd3;
}
