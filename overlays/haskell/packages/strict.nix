{ mkDerivation
, assoc
, base
, binary
, bytestring
, deepseq
, ghc-prim
, hashable
, stdenv
, text
, these
, transformers
}:
mkDerivation {
  pname = "strict";
  version = "0.4";
  sha256 = "279fee78690409ce0878beead4a620f0c0975dba215d6778f183699e3576453f";
  libraryHaskellDepends = [
    assoc
    base
    binary
    bytestring
    deepseq
    ghc-prim
    hashable
    text
    these
    transformers
  ];
  homepage = "https://github.com/haskell-strict/strict";
  description = "Strict data types and String IO";
  license = stdenv.lib.licenses.bsd3;
}
