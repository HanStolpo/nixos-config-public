{ mkDerivation, array, base, bytestring, containers, regex-base
, stdenv
}:
mkDerivation {
  pname = "regex-posix";
  version = "0.96.0.0";
  sha256 = "251300f1a6bb2e91abb8bf513a21981f8fab79c98a65acea2bb6d6a524414521";
  libraryHaskellDepends = [
    array base bytestring containers regex-base
  ];
  description = "POSIX Backend for \"Text.Regex\" (regex-base)";
  license = stdenv.lib.licenses.bsd3;
}
