{ mkDerivation
, aeson
, base
, containers
, data-default
, Diff
, fetchgit
, ghc
, ghc-boot-th
, ghcide
, haskell-lsp
, hslogger
, lens
, process
, regex-tdfa
, shake
, stdenv
, text
, unordered-containers
}:
mkDerivation {
  pname = "hls-plugin-api";
  version = "0.4.1.0";
  src = fetchgit {
    url = "https://github.com/haskell/haskell-language-server";
    sha256 = "0vkh5ff6l5wr4450xmbki3cfhlwf041fjaalnwmj7zskd72s9p7p";
    rev = "14497f2503a2a0d389fabf3b146d674b9af41a34";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/hls-plugin-api; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson
    base
    containers
    data-default
    Diff
    ghc
    ghc-boot-th
    ghcide
    haskell-lsp
    hslogger
    lens
    process
    regex-tdfa
    shake
    text
    unordered-containers
  ];
  homepage = "https://github.com/haskell/haskell-language-server/hls-plugin-api";
  description = "Haskell Language Server API for plugin communication";
  license = stdenv.lib.licenses.asl20;
}
