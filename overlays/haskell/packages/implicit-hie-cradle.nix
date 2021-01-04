{ mkDerivation
, base
, base16-bytestring
, bytestring
, containers
, directory
, extra
, filepath
, hie-bios
, hslogger
, implicit-hie
, process
, stdenv
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
  pname = "implicit-hie-cradle";
  version = "0.2.0.1";
  sha256 = "a1612b7591edaa2ae13299ff41c5a20084683a629b6fd80e7c4d1f52780151d0";
  libraryHaskellDepends = [
    base
    base16-bytestring
    bytestring
    containers
    directory
    extra
    filepath
    hie-bios
    hslogger
    implicit-hie
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
  testHaskellDepends = [ base ];
  homepage = "https://github.com/Avi-D-coder/implicit-hie-cradle#readme";
  description = "Auto generate hie-bios cradles";
  license = stdenv.lib.licenses.bsd3;
}
