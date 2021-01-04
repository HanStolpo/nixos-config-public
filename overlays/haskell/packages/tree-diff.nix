{ mkDerivation
, aeson
, ansi-terminal
, ansi-wl-pprint
, base
, base-compat
, bytestring
, bytestring-builder
, containers
, hashable
, parsec
, parsers
, pretty
, QuickCheck
, scientific
, stdenv
, tagged
, tasty
, tasty-golden
, tasty-quickcheck
, text
, time
, trifecta
, unordered-containers
, uuid-types
, vector
}:
mkDerivation {
  pname = "tree-diff";
  version = "0.1";
  sha256 = "e3d901ad6f3e2732f07e0dafcafb27bef2f2cadec46bf9c9a5c95e60f1b2a684";
  revision = "5";
  editedCabalFile = "1b60x9cgp7hn42hc97q866ybhg5hx3sp45j6gngpbwryg29r2p4h";
  libraryHaskellDepends = [
    aeson
    ansi-terminal
    ansi-wl-pprint
    base
    base-compat
    bytestring
    bytestring-builder
    containers
    hashable
    parsec
    parsers
    pretty
    QuickCheck
    scientific
    tagged
    text
    time
    unordered-containers
    uuid-types
    vector
  ];
  testHaskellDepends = [
    ansi-terminal
    ansi-wl-pprint
    base
    base-compat
    parsec
    QuickCheck
    tagged
    tasty
    tasty-golden
    tasty-quickcheck
    trifecta
  ];
  homepage = "https://github.com/phadej/tree-diff";
  description = "Diffing of (expression) trees";
  license = stdenv.lib.licenses.gpl2Plus;
}
