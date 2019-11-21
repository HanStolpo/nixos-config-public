self: super:
let

  haskell = super.haskell // {
    packages = builtins.mapAttrs (
      name: value:
        let
          selfPkgs = self;
          superPkgs = super;
        in
          value.override {
            overrides =
              with superPkgs.lib.attrsets;
              with superPkgs.haskell.lib;
              self: super: {

                wstunnel = justStaticExecutables (doJailbreak (self.callPackage ./haskell/wstunnel.nix {}));

                extra = self.callPackage (import ./haskell/extra.nix) {};
                ghcide = self.callPackage (import ./haskell/ghcide.nix) {};
                haskell-lsp-types = self.callPackage (import ./haskell/haskell-lsp-types.nix) {};
                haskell-lsp = self.callPackage (import ./haskell/haskell-lsp.nix) {};
                hie-bios = self.callPackage (import ./haskell/hie-bios.nix) {};
                lsp-test = self.callPackage (import ./haskell/lsp-test.nix) {};
                rope-utf16-splay = self.callPackage (import ./haskell/rope-utf16-splay.nix) {};
                unix-compat = self.callPackage (import ./haskell/unix-compat.nix) {};
                yaml = self.callPackage (import ./haskell/yaml.nix) {};
                unordered-containers = self.callPackage (import ./haskell/unordered-containers.nix) {};
                ormolu = self.callPackage (import ./haskell/ormolu.nix) {};
                ch-hs-format = self.callPackage (import ./haskell/ch-hs-format.nix) {};


                streaming-process =
                  doJailbreak (
                    self.callPackage
                      /home/handre/dev/ch-hs-imports/nix/overlays/haskell/streaming-process.nix {}
                  );
                ch-hs-imports =
                  self.callPackage (import ./haskell/ch-hs-imports.nix) {};

              };
          }
    ) super.haskell.packages;
  };

  pkgs-legacy = import (
    super.fetchzip {
      url = "https://github.com/NixOS/nixpkgs-channels/archive/2d6f84c1090ae39c58dcec8f35a3ca62a43ad38c.tar.gz";
      sha256 = "0l8b51lwxlqc3h6gy59mbz8bsvgc0q6b3gf7p3ib1icvpmwqm773";
      name = "pkgs-legacy";
    }
  ) {
    config = { allowUnfree = true; };
    overlays = [
      (
        self: super: rec {
          haskell = super.haskell // {
            packages = builtins.mapAttrs (
              name: value:
                let
                  selfPkgs = self;
                  superPkgs = super;
                in
                  value.override {
                    overrides =
                      with superPkgs.lib.attrsets;
                      with superPkgs.haskell.lib;
                      self: super: {
                        monad-dijkstra = self.callPackage ./haskell/monad-dijkstra.nix {};
                        yaml_0_11_0_0 = self.callPackage ./haskell/yaml_0_11_0_0.nix {};
                        hpack_0_31_1 = self.callPackage ./haskell/hpack_0_31_1.nix {
                          yaml = self.yaml_0_11_0_0;
                        };
                        taffybar = self.callPackage
                          (import ./haskell/taffybar.nix)
                          { gtk3 = selfPkgs.gnome3.gtk; };
                        broadcast-chan = self.callPackage (import ./haskell/broadcast-chan.nix) {};
                        xmonad-windownames = doJailbreak super.xmonad-windownames;
                        xmonad-extras = doJailbreak super.xmonad-extras;
                        Diff = dontCheck super.Diff;
                      };
                  }
            ) super.haskell.packages;
          };
          haskellPackages = haskell.packages.ghc863;
        }
      )
    ];
  };


  fetch-lorri-src = super.fetchgit {
    url = "https://github.com/target/lorri";
    sha256 = "0djmmk24mq7936wmp6hpcg5w3g5q90dxd91z0v3n4n82xjr8y54m";
    rev = "fdfeae9ce4d783db59e5c0f020a606cbfd4b0556";
    fetchSubmodules = false;
  };
  lorri-nixpkgs =
    import
      (builtins.toPath "${fetch-lorri-src}/nix/nixpkgs.nix") {
      enableMozillaOverlay = false;
    };
  lorri =
    self.callPackage
      (builtins.toPath "${fetch-lorri-src}/default.nix") {
      src = (builtins.toPath "${fetch-lorri-src}");
      pkgs = lorri-nixpkgs;
    };
in
rec {
  inherit pkgs-legacy;
  inherit lorri;
  direnv = lorri-nixpkgs.direnv;
  create-react-native-app = (self.callPackage ./create-react-native-app {});
  expo-exp = (self.callPackage ./expo-exp {});
  stack2nix = self.haskell.lib.doJailbreak super.stack2nix;
  inherit haskell;
  haskellPackages = haskell.packages.ghc865;
  mykicad = super.kicad.overrideAttrs (
    oldAttrs: rec {
      name = "mikicad";
      src = super.fetchFromGitHub {
        owner = "KICad";
        repo = "kicad-source-mirror";
        rev = "d132cf37e0e08a83b16820f6e04757b7d3753548";
        sha256 = "1rj78y9ix89jbql12l25rm0pjwjswmyxkvr4461y1sf26ydla823";
      };
    }
  );
  ormolu = haskellPackages.ormolu;

  slack = self.callPackage ./slack { gdk-pixbuf = self.gdk_pixbuf; };

} // ((import ./ghci-bios) self super)
