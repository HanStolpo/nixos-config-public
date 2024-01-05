{ stdenv
, fetchurl
, gnutar
, findutils
, lib
}:

let
  version = "1.1.2";
  os = "linux";
  platform = "amd64";
  sha256 = "04i31ajxi6ahkskxzq2ddrl2avwx971hrb2znbvskzwnz5v4djlk";
in

stdenv.mkDerivation {
  meta = with lib; {
    description = "Simple markdown renderer with live reloading.";
    longDescription = ''
      mdsync is like browsersync, but for markdown. It renders Markdown to HTML and reloads the browser when changes are made.
    '';
    homepage = "https://github.com/rverst/mdsync";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
  pname = "mdsync";
  inherit version;
  src = fetchurl {
    url = "https://github.com/rverst/mdsync/releases/download/v${version}/mdsync_${version}_${os}_${platform}.tar.gz";
    inherit sha256;
  };
  dontUnpack = true;
  buildInputs = [ gnutar ];
  buildPhase = ''
    tar xvf $src
    chmod +x mdsync
  '';
  installPhase = ''
    echo "making output directory"
    mkdir -p $out/bin

    echo "copying to output"
    cp mdsync $out/bin
  '';
}
