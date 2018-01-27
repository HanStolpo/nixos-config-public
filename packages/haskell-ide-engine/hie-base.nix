{ mkDerivation, aeson, base, fetchgit, haskell-lsp, stdenv, text }:
mkDerivation {
  pname = "hie-base";
  version = "0.1.0.0";
  src = import ./haskell-ide-engine-src.nix {inherit fetchgit;};
  postUnpack = "sourceRoot+=/hie-base; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ aeson base haskell-lsp text ];
  description = "Haskell IDE API base types";
  license = stdenv.lib.licenses.bsd3;
}
