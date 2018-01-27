{ pkgs ? (import <nixpkgs> {})
, haskellCompiler ? "ghc822"
}:
let
  haskellPackages = pkgs.haskell.packages.${haskellCompiler};
  inherit (pkgs) haskell fetchFromGitHub system;
  inherit (haskell.lib) overrideCabal dontCheck dontHaddock;
  inherit (pkgs.lib) composeExtensions;
in
  (haskellPackages.override (old: {
    overrides =
      composeExtensions
        (old.overrides or (_: _: {}))
        (self: super:
          import
            (if haskellCompiler == "ghc802"
            then ./haskell-packages-ghc802.nix
            else ./haskell-packages.nix) {
              callPackage = self.callPackage;
              inherit dontCheck dontHaddock super;});
  })).haskell-ide-engine
