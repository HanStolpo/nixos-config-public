{ mkDerivation
, attoparsec
, base
, directory
, filepath
, filepattern
, hspec
, hspec-attoparsec
, stdenv
, text
, transformers
, yaml
}:
mkDerivation {
  pname = "implicit-hie";
  version = "0.1.0.0";
  sha256 = "26b74f6f21600da4fd74631fbebc014a65f9f539d7e2b2bc4078d64bf2deaad5";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    attoparsec
    base
    directory
    filepath
    filepattern
    text
    transformers
    yaml
  ];
  executableHaskellDepends = [
    attoparsec
    base
    directory
    filepath
    filepattern
    text
    transformers
    yaml
  ];
  testHaskellDepends = [
    attoparsec
    base
    directory
    filepath
    filepattern
    hspec
    hspec-attoparsec
    text
    transformers
    yaml
  ];
  doCheck = false;
  homepage = "https://github.com/Avi-D-coder/implicit-hie#readme";
  description = "Auto generate hie-bios cradles & hie.yaml";
  license = stdenv.lib.licenses.bsd3;
}
