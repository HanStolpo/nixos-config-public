args@{ callPackage, dontCheck, dontHaddock, super, ... }:
let
  newest = import ./haskell-packages.nix args;
in
newest // {
  haddock-api = callPackage ./haddock-api-2.17.4.nix {};
  haddock-library = callPackage ./haddock-library-1.4.3.nix {};
  singletons = dontCheck (callPackage ./singletons-2.2.nix {});
  th-desugar = callPackage ./th-desugar-1.6.nix {};
  haskell-lsp = dontHaddock (super.haskell-lsp);
  hie-build-plugin = dontHaddock (newest.hie-build-plugin);
}
