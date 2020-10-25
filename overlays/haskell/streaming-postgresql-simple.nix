{ mkDerivation
, base
, bytestring
, exceptions
, postgresql-libpq
, postgresql-simple
, resourcet
, safe-exceptions
, stdenv
, streaming
, transformers
}:
mkDerivation {
  pname = "streaming-postgresql-simple";
  version = "0.2.0.5";
  sha256 = "0a37d84e22c60d292e3b5f2660fc1d1be3b1ff0c1a7cf37ffd7eb70e530252bd";
  libraryHaskellDepends = [
    base
    bytestring
    exceptions
    postgresql-libpq
    postgresql-simple
    resourcet
    safe-exceptions
    streaming
    transformers
  ];
  description = "Stream postgresql-query results using the streaming library";
  license = stdenv.lib.licenses.bsd3;
}
