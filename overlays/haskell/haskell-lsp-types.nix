{ mkDerivation, aeson, base, bytestring, data-default, deepseq
, fetchgit, filepath, hashable, lens, network-uri, scientific
, stdenv, text, unordered-containers
}:
mkDerivation {
  pname = "haskell-lsp-types";
  version = "0.17.0.0";
  src = fetchgit {
    url = "https://github.com/alanz/haskell-lsp";
    sha256 = "1nc8zq0l68my2lly98m56ix028y9vwx2fwfi7bpbl1z0wp0jfwxy";
    rev = "d624794067181f9311581942eb6fc69ebfc0cf65";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/haskell-lsp-types; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring data-default deepseq filepath hashable lens
    network-uri scientific text unordered-containers
  ];
  homepage = "https://github.com/alanz/haskell-lsp";
  description = "Haskell library for the Microsoft Language Server Protocol, data types";
  license = stdenv.lib.licenses.mit;
}
