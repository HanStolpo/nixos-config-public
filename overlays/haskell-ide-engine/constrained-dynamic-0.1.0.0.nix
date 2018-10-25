{ mkDerivation, base, stdenv, tasty, tasty-hunit }:
mkDerivation {
  pname = "constrained-dynamic";
  version = "0.1.0.0";
  sha256 = "20952857c40fcb730584000d2a98e6a89f9f457b86e5e035ae055b40919c8f49";
  libraryHaskellDepends = [ base ];
  testHaskellDepends = [ base tasty tasty-hunit ];
  description = "Dynamic typing with retained constraints";
  license = stdenv.lib.licenses.mit;
}
