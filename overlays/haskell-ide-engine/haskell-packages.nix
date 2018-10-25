{ callPackage, dontCheck, ...}:
{
  ghc-dump-tree = callPackage ./ghc-dump-tree-50f8b28.nix {};
  hoogle = callPackage ./hoogle-5.0.13.nix {};
  haskell-src-exts = callPackage ./haskell-src-exts-1.19.1.nix {};
  HaRe = dontCheck (callPackage ./HaRe-e32597545.nix {});
  constrained-dynamic = callPackage ./constrained-dynamic-0.1.0.0.nix {};
  unix-compat = callPackage ./unix-compat-0.4.3.1.nix {};
  cabal-helper = callPackage ./cabal-helper.nix {};
  ghc-mod-core = callPackage (import ./ghc-mod-core.nix){};
  ghc-mod = callPackage (import ./ghc-mod.nix){};
  haskell-ide-engine = dontCheck(callPackage (import ./haskell-ide-engine.nix){});
  hie-apply-refact = callPackage (import ./hie-apply-refact.nix){};
  hie-base = callPackage (import ./hie-base.nix){};
  hie-brittany = callPackage (import ./hie-brittany.nix){};
  hie-build-plugin = callPackage (import ./hie-build-plugin.nix){};
  hie-example-plugin2 = callPackage (import ./hie-example-plugin2.nix){};
  hie-ghc-haddock = callPackage (import ./hie-ghc-haddock.nix){};
  hie-ghc-mod = callPackage (import ./hie-ghc-mod.nix){};
  hie-haddock = callPackage (import ./hie-haddock.nix){};
  hie-hare = callPackage (import ./hie-hare.nix){};
  hie-hoogle = callPackage (import ./hie-hoogle.nix){};
  hie-plugin-api = callPackage (import ./hie-plugin-api.nix){};
}

