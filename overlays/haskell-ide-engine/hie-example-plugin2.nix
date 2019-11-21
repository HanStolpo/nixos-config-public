{ mkDerivation, base, fetchgit, hie-plugin-api, stdenv, text }:
mkDerivation {
  pname = "hie-example-plugin2";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix { inherit fetchgit; };
  postUnpack = "sourceRoot+=/hie-example-plugin2; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base hie-plugin-api text ];
  description = "Haskell IDE example plugin";
  license = stdenv.lib.licenses.bsd3;
}
