{ mkDerivation
, aeson
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
  version = "0.4.0";
  sha256 = "81881340e208e39b3f065898cc2eff5f12300cf9a50c17ce4883566da4e448dd";
  revision = "1";
  editedCabalFile = "12m0hy4lirnr02h0nh2a85cfm8jv7jgqh24fdn29jkc28gpspm72";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
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
    extra
    filepath
    ghc
    tasty
    tasty-hunit
    text
    unordered-containers
    yaml
  ];
  doCheck = false;
  homepage = "https://github.com/mpickering/hie-bios";
  description = "Set up a GHC API session";
  license = stdenv.lib.licenses.bsd3;
}
