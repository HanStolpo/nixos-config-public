{ mkDerivation
, aeson
, attoparsec
, base
, bytestring
, http-client
, http-client-tls
, json-stream
, mtl
, network
, network-simple
, pipes
, resourcet
, stdenv
, streaming
, streaming-bytestring
, streaming-commons
, transformers
}:
mkDerivation {
  pname = "streaming-utils";
  version = "0.2.0.0";
  sha256 = "13763aa2440e8daa24be31ef0391832385b1c18ffcbdeefb7010e6ceaf678f15";
  libraryHaskellDepends = [
    aeson
    attoparsec
    base
    bytestring
    http-client
    http-client-tls
    json-stream
    mtl
    network
    network-simple
    pipes
    resourcet
    streaming
    streaming-bytestring
    streaming-commons
    transformers
  ];
  jailbreak = true;
  homepage = "https://github.com/michaelt/streaming-utils";
  description = "http, attoparsec, pipes and other utilities for the streaming libraries";
  license = stdenv.lib.licenses.bsd3;
}
