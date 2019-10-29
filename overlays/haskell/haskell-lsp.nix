{ mkDerivation, aeson, async, attoparsec, base, bytestring
, containers, data-default, directory, fetchgit, filepath, hashable
, haskell-lsp-types, hslogger, hspec, hspec-discover, lens, mtl
, network-uri, QuickCheck, quickcheck-instances, rope-utf16-splay
, sorted-list, stdenv, stm, temporary, text, time
, unordered-containers
}:
mkDerivation {
  pname = "haskell-lsp";
  version = "0.17.0.0";
  src = fetchgit {
    url = "https://github.com/alanz/haskell-lsp";
    sha256 = "1nc8zq0l68my2lly98m56ix028y9vwx2fwfi7bpbl1z0wp0jfwxy";
    rev = "d624794067181f9311581942eb6fc69ebfc0cf65";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async attoparsec base bytestring containers data-default
    directory filepath hashable haskell-lsp-types hslogger lens mtl
    network-uri rope-utf16-splay sorted-list stm temporary text time
    unordered-containers
  ];
  testHaskellDepends = [
    aeson base bytestring containers data-default directory filepath
    hashable hspec lens network-uri QuickCheck quickcheck-instances
    rope-utf16-splay sorted-list stm text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/alanz/haskell-lsp";
  description = "Haskell library for the Microsoft Language Server Protocol";
  license = stdenv.lib.licenses.mit;
}
