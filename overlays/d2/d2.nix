{ stdenv
, fetchurl
, gnutar
, findutils
, lib
}:

let
  version = "0.6.5";
  os = "linux";
  platform = "amd64";
  sha256 = "0d57h4r06q5jsl8mwb02zpjkdwdj12gfrivqafv3fcr6mwcjjw0p";
  extractDir = "d2-v${version}";
in

stdenv.mkDerivation {
  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams.";
    longDescription = ''
      D2 is a modern diagram scripting language that turns text to diagrams. 
    '';
    homepage = "https://d2lang.com/";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
  pname = "d2";
  inherit version;
  src = fetchurl {
    url = "https://github.com/terrastruct/d2/releases/download/v${version}/d2-v${version}-${os}-${platform}.tar.gz";
    inherit sha256;
  };
  buildInputs = [ gnutar ];
  buildPhase = ''
    tar xvf $src
    chmod +x ${extractDir}/bin/d2
  '';
  installPhase = ''
    echo "making output directory"
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    echo "copying to output"
    cp ${extractDir}/bin/d2 $out/bin
    cp -r ${extractDir}/man/* $out/share/man/man1
  '';
}
