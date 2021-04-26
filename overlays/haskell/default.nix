final: prev:
let
  inherit (prev.lib) composeExtensions;

  haskell = prev.haskell // {
    packages = builtins.mapAttrs
      (
        name: value:
          let
            selfPkgs = final;
            superPkgs = prev;
            configurations =
              with superPkgs.lib.attrsets;
              with superPkgs.haskell.lib;
              self: super: rec {
                wstunnel = justStaticExecutables (doJailbreak super.wstunnel);
                ch-hs-imports = justStaticExecutables (doJailbreak super.ch-hs-imports);
              };
          in
          value.override {
            overrides =
              composeExtensions
                (superPkgs.haskell.lib.packagesFromDirectory { directory = ./packages; })
                configurations;
          }
      )
      prev.haskell.packages;
  };

in
rec {

  inherit haskell;
  haskellPackages = final.haskell.packages.ghc8104;

}
