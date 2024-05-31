{ stdenv
, fetchurl
, gnutar
, findutils
, lib
}:

let
  version = "0.3.14";
  os = "linux";
  platform = "amd64";
  sha256 = "17kgsqyaszml3vph8a2w1mj2fxa5g5zn6rvybyzx8nwfswlmdk4w";
  extractDir = "tala-v${version}";
in

stdenv.mkDerivation {
  meta = with lib; {
    description = "A diagram layout engine designed specifically for software architecture diagrams.";
    longDescription = ''
      TALA is a diagram layout engine designed specifically for software architecture diagrams, though it works well in other domains too. TALA is closed-source (for now).
    '';
    homepage = "https://terrastruct.com/tala";
  };
  pname = "tala";
  inherit version;
  src = fetchurl {
    url = "https://github.com/terrastruct/TALA/releases/download/v${version}/tala-v${version}-${os}-${platform}.tar.gz";
    inherit sha256;
  };
  buildInputs = [ gnutar ];
  buildPhase = ''
    tar xvf $src
    chmod +x ${extractDir}/bin/d2plugin-tala
  '';
  installPhase = ''
    echo "making output directory"
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    echo "copying to output"
    cp ${extractDir}/bin/d2plugin-tala $out/bin
    cp -r ${extractDir}/man/* $out/share/man/man1
  '';
}
