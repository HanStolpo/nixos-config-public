{ mkDerivation, array, base, bytestring, containers, regex-base
, stdenv, text
}:
mkDerivation {
  pname = "regex-pcre-builtin";
  version = "0.95.1.1.8.43";
  sha256 = "4d3b108482982c6f188b740bcb4959d39c47bf05955fcb17068a5c9916d171aa";
  libraryHaskellDepends = [
    array base bytestring containers regex-base text
  ];
  description = "PCRE Backend for \"Text.Regex\" (regex-base)";
  license = stdenv.lib.licenses.bsd3;
}
