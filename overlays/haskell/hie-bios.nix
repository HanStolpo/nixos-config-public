{ mkDerivation
, base
, base16-bytestring
, bytestring
, conduit
, conduit-extra
, containers
, cryptohash-sha1
, deepseq
, directory
, extra
, file-embed
, filepath
, ghc
, hslogger
, process
, stdenv
, tasty
, tasty-hunit
, temporary
, text
, time
, transformers
, unix-compat
, unordered-containers
, vector
, yaml
}:
mkDerivation {
  pname = "hie-bios";
  version = "0.3.2";
  sha256 = "39eec9049e0ce46b9185a653a7d6d2de17bc860470054668c78a06f8e4ce0998";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    base16-bytestring
    bytestring
    conduit
    conduit-extra
    containers
    cryptohash-sha1
    deepseq
    directory
    extra
    file-embed
    filepath
    ghc
    hslogger
    process
    temporary
    text
    time
    transformers
    unix-compat
    unordered-containers
    vector
    yaml
  ];
  executableHaskellDepends = [ base directory filepath ghc ];
  testHaskellDepends = [
    base
    directory
    filepath
    ghc
    tasty
    tasty-hunit
  ];
  doCheck = false;
  homepage = "https://github.com/mpickering/hie-bios";
  description = "Set up a GHC API session";
  license = stdenv.lib.licenses.bsd3;
}
