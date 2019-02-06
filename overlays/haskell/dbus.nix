{ mkDerivation, base, bytestring, cereal, containers, criterion
, deepseq, directory, extra, filepath, lens, libxml-sax, network
, parsec, process, QuickCheck, random, resourcet, split, stdenv
, tasty, tasty-hunit, tasty-quickcheck, template-haskell, text
, th-lift, transformers, unix, vector, xml-types
}:
mkDerivation {
  pname = "dbus";
  version = "1.0.1";
  sha256 = "a325b5c6958a343b30fd378d54ac01f9db889a4d7cadb14b2103da7ef4e7e8f5";
  revision = "1";
  editedCabalFile = "043jh8sdizn17xy4hxjbal7pvdh2mc50vdplybpjxvxr4f1jl076";
  libraryHaskellDepends = [
    base bytestring cereal containers deepseq filepath lens libxml-sax
    network parsec random split template-haskell text th-lift
    transformers unix vector xml-types
  ];
  testHaskellDepends = [
    base bytestring cereal containers directory extra filepath
    libxml-sax network parsec process QuickCheck random resourcet tasty
    tasty-hunit tasty-quickcheck text transformers unix vector
    xml-types
  ];
  benchmarkHaskellDepends = [ base criterion ];
  doCheck = false;
  homepage = "https://github.com/rblaze/haskell-dbus#readme";
  description = "A client library for the D-Bus IPC system";
  license = stdenv.lib.licenses.asl20;
}
