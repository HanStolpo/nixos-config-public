{ mkDerivation, aeson, attoparsec, base, base-compat, bytestring
, cmdargs, scientific, stdenv, text, unordered-containers, vector
}:
mkDerivation {
  pname = "aeson-pretty";
  version = "0.8.8";
  sha256 = "81cea61cb6dcf32c3f0529ea5cfc98dbea3894152d7f2d9fe1cb051f927ec726";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base-compat bytestring scientific text
    unordered-containers vector
  ];
  executableHaskellDepends = [
    aeson attoparsec base bytestring cmdargs
  ];
  homepage = "http://github.com/informatikr/aeson-pretty";
  description = "JSON pretty-printing library and command-line tool";
  license = stdenv.lib.licenses.bsd3;
}
