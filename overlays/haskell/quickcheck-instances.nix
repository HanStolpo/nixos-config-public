{ mkDerivation, array, base, base-compat, bytestring
, case-insensitive, containers, hashable, old-time, QuickCheck
, scientific, splitmix, stdenv, tagged, text, time, time-compat
, transformers, transformers-compat, unordered-containers
, uuid-types, vector
}:
mkDerivation {
  pname = "quickcheck-instances";
  version = "0.3.22";
  sha256 = "5d65bf81895b7af2d36f105d0b3afa5600b0bce0a14809c93d7ca87672ca5a91";
  revision = "2";
  editedCabalFile = "1ia5fjhpg7rz793552v88gv2iqx7hl9mi2g09m0llasy1cpzc9jr";
  libraryHaskellDepends = [
    array base base-compat bytestring case-insensitive containers
    hashable old-time QuickCheck scientific splitmix tagged text time
    time-compat transformers transformers-compat unordered-containers
    uuid-types vector
  ];
  testHaskellDepends = [
    base containers QuickCheck tagged uuid-types
  ];
  benchmarkHaskellDepends = [ base bytestring QuickCheck ];
  homepage = "https://github.com/phadej/qc-instances";
  description = "Common quickcheck instances";
  license = stdenv.lib.licenses.bsd3;
}
