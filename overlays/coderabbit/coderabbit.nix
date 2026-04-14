{ stdenv
, fetchurl
, patchelf
, findutils
, unzip
, lib
}:

let
  version = "0.4.1";
  os = "linux";
  platform = "x64";
  sha256 = "0g00h4isdwk3hj9mzsl5bbm4h1skdsx5v0sfnn0hmnmnq0ifdswg";
in

stdenv.mkDerivation {
  name = "coderabbit-${version}";
  inherit version;
  src = fetchurl {
    url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-${os}-${platform}.zip";
    inherit sha256;
  };
  buildInputs = [ patchelf unzip ];
  dontUnpack = true;
  buildPhase = ''
    export INTERPRETER=$(cat $NIX_CC/nix-support/dynamic-linker)
    echo "INTERPRETER=$INTERPRETER"

    mkdir -p $out/bin
    unzip $src -d $out/bin
    chmod +wx $out/bin/coderabbit

    echo "patching interpreter"
    patchelf --set-interpreter \
      "$INTERPRETER" \
      $out/bin/coderabbit
  '';
}
