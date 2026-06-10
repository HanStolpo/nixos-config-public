{ stdenv
, fetchurl
, patchelf
, findutils
, unzip
, lib
}:

let
  version = "0.5.3";
  os = "linux";
  platform = "x64";
  sha256 = "19a6sp6kkb4pkvv02mzvmmd1fnan64hvlwg70x430r2b5f6chisa";
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
  dontInstall = true;
  dontFixup = true;
  buildPhase = ''
    export INTERPRETER=$(cat $NIX_CC/nix-support/dynamic-linker)
    echo "INTERPRETER=$INTERPRETER"

    mkdir -p $out/bin
    unzip $src -d $out/bin
    chmod +x $out/bin/coderabbit

    echo "patching interpreter"
    patchelf --set-interpreter \
      "$INTERPRETER" \
      $out/bin/coderabbit
  '';
}
