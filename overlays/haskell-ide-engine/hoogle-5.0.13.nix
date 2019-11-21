{ mkDerivation
, aeson
, base
, binary
, bytestring
, cmdargs
, conduit
, conduit-extra
, connection
, containers
, deepseq
, directory
, extra
, filepath
, haskell-src-exts
, http-conduit
, http-types
, js-flot
, js-jquery
, mmap
, network
, network-uri
, old-locale
, process
, process-extras
, QuickCheck
, resourcet
, stdenv
, tar
, template-haskell
, text
, time
, transformers
, uniplate
, utf8-string
, vector
, wai
, wai-logger
, warp
, warp-tls
, zlib
}:
mkDerivation {
  pname = "hoogle";
  version = "5.0.13";
  sha256 = "76a229eb4b6177e8cb5eb8f2c2ec42cb72ec5b224e1792ffb56bd4e7e2fcadf3";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson
    base
    binary
    bytestring
    cmdargs
    conduit
    conduit-extra
    connection
    containers
    deepseq
    directory
    extra
    filepath
    haskell-src-exts
    http-conduit
    http-types
    js-flot
    js-jquery
    mmap
    network
    network-uri
    old-locale
    process
    process-extras
    QuickCheck
    resourcet
    tar
    template-haskell
    text
    time
    transformers
    uniplate
    utf8-string
    vector
    wai
    wai-logger
    warp
    warp-tls
    zlib
  ];
  executableHaskellDepends = [ base ];
  testTarget = "--test-option=--no-net";
  homepage = "http://hoogle.haskell.org/";
  description = "Haskell API Search";
  license = stdenv.lib.licenses.bsd3;
}
