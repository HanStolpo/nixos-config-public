{ mkDerivation, base, mtl, QuickCheck, stdenv, stm
, template-haskell, test-framework, test-framework-hunit
, test-framework-quickcheck2, transformers, transformers-compat
}:
mkDerivation {
  pname = "exceptions";
  version = "0.10.0";
  sha256 = "1edd912e5ea5cbda37941b06738597d35214dc247d332b1bfffc82adadfa49d7";
  revision = "2";
  editedCabalFile = "0aiihbjfrlmxzw9q8idvr6mihhs7kbx9s3w1vj8x3pz27p0ncq7g";
  libraryHaskellDepends = [
    base mtl stm template-haskell transformers transformers-compat
  ];
  testHaskellDepends = [
    base mtl QuickCheck stm template-haskell test-framework
    test-framework-hunit test-framework-quickcheck2 transformers
    transformers-compat
  ];
  homepage = "http://github.com/ekmett/exceptions/";
  description = "Extensible optionally-pure exceptions";
  license = stdenv.lib.licenses.bsd3;
  jailbreak = true;
}
