{ mkDerivation
, async
, base
, base64-bytestring
, binary
, bytestring
, classy-prelude
, cmdargs
, connection
, fetchgit
, hslogger
, mtl
, network
, network-conduit-tls
, stdenv
, streaming-commons
, text
, unordered-containers
, websockets
}:
mkDerivation {
  pname = "wstunnel";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/HanStolpo/wstunnel";
    sha256 = "1f1v1cx0vxbj3861d3dw799cwc6mhrfnwhmrxgzr93qli494bnw0";
    rev = "847f62b84a66ff9124934e13f8434ca005e8a57e";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    async
    base
    base64-bytestring
    binary
    bytestring
    classy-prelude
    cmdargs
    connection
    hslogger
    mtl
    network
    network-conduit-tls
    streaming-commons
    text
    unordered-containers
    websockets
  ];
  executableHaskellDepends = [
    base
    bytestring
    classy-prelude
    cmdargs
    hslogger
    text
  ];
  testHaskellDepends = [ base text ];
  homepage = "https://github.com/githubuser/wstunnel#readme";
  description = "Initial project template from stack";
  license = stdenv.lib.licenses.bsd3;
}
