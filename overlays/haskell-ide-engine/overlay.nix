{ haskellCompiler ? "ghc822" }:
[
  (
    self: super:
      let
        inherit (self) haskell fetchFromGitHub system;
        inherit (haskell.lib) overrideCabal dontCheck;
        inherit (super.lib) composeExtensions;
      in
        {
          haskellPackages = super.haskell.packages.${haskellCompiler}.override (
            old:
              {
                overrides = composeExtensions (old.overrides or (_: _: {}))
                  (self: super: import ./haskell-packages.nix { callPackage = self.callPackage; inherit dontCheck; });
              }
          );
        }
  )
]
