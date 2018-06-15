{ pkgs, ... }:

let


  haskellOverrides = with pkgs.haskell.lib; packages: compiler: {
    ${compiler} = packages.${compiler}.override {
      overrides = self: super:
      let
        # below copied from nixpkgs pkgs/development/haskell-modules/make-package-set.nix
        # Adds a nix file as an input to the haskell derivation it
        # produces. This is useful for callHackage / callCabal2nix to
        # prevent the generated default.nix from being garbage collected
        # (requiring it to be frequently rebuilt), which can be an
        # annoyance.
        callPackageKeepDeriver = src: args:
          overrideCabal (self.callPackage src args) (orig: {
            preConfigure = ''
              # Generated from ${src}
              ${orig.preConfigure or ""}
            '';
          });
      in {
        haskell-ide-engine = import ./haskell-ide-engine {inherit pkgs; haskellCompiler = "ghc802";};
        # we override used by ghc-mod below because it fails its test suite
        ghc-syb-utils = dontCheck super.ghc-syb-utils;
        #
        xmonad-windownames = doJailbreak super.xmonad-windownames;
        #
        hnix = doJailbreak super.hnix;
        #
        taffybar = pkgs-18-0-3.haskell.packages.${compiler}.taffybar;
        #
        opencv =
        let
            srcGit =  pkgs.fetchFromGitHub {
                  owner  = "LumiGuide";
                  repo   = "haskell-opencv";
                  rev    = "433abd5dd7d885a04b79e42efb0efcecdb985eed";
                  sha256 = "0makqxcbmnf02a5xaq6kzfb6lplnchh9dcbknamh32y2iswjdbx3";
                };
                src = pkgs.runCommand "opencv-src"
                        {
                        } ''
                          mkdir -p $out
                          cp -r ${srcGit}/opencv/*  $out
                          rm $out/data $out/doc $out/LICENSE
                          cp -r ${srcGit}/doc     $out/doc
                          cp -r ${srcGit}/data    $out/data
                          cp ${srcGit}/LICENSE   $out/LICENSE
                        '';
          in overrideCabal ( ( (self.callCabal2nix "opencv" src {}))) (drv: {
                libraryPkgconfigDepends = [ pkgs.opencv3 ];
                shellHook = ''
                  export hardeningDisable=bindnow
                '';
                # TODO: cabal2nix automatically adds:
                #
                #   configureFlags = ["--with-gcc=${stdenv.cc}/bin/c++" "--with-ld=${stdenv.cc}/bin/c++"];
                #
                # This is not needed anymore and will actually break the build.
                # So lets remove this from cabal2nix or ask @peti to do it.
                configureFlags = [];
          });
          #
          units-parser = dontCheck super.units-parser;
          units = dontCheck super.units;
          hindent = self.callCabal2nix "hindent"
            (pkgs.fetchFromGitHub {
                  owner  = "commercialhaskell";
                  repo   = "hindent";
                  rev    = "9cc9ed7f6bd8b16309e61397a0cf88d8df153b29";
                  sha256 = "06syaj5qr0899v0qmmshn3728bxaf4n99d1phh9q21yvlz17j0dn";
            })
            {};
          descriptive = self.callCabal2nix "descriptive"
            (pkgs.fetchFromGitHub {
                  owner  = "chrisdone";
                  repo   = "descriptive";
                  rev    = "c088960113b2add758553e41cbe439d183b750cd";
                  sha256 = "17p65ihcvm1ghq23ww6phh8gdj7hwxlypjvh9jabsxvfbp2s8mrk";
            })
            {};
          intero = doJailbreak (dontCheck (self.callCabal2nix "intero"
            (pkgs.fetchFromGitHub {
                  owner  = "commercialhaskell";
                  repo   = "intero";
                  rev    = "b470a806479364bca15de4f7bbba358287174bbd";
                  sha256 = "01q9sansb50ccjydh65blzcl9b0xaxy09mbjz3481r1qjifnw150";
            })
            {ghc = self.ghc;}));

            reactive-banana-gi-gtk =
            let src = pkgs.fetchFromGitHub {
                  owner  = "mr";
                  repo   = "reactive-banana-gi-gtk";
                  rev    = "18b0b5585762382578f55931feb7332b243d9cd3";
                  sha256 = "11sns2s53gn8q2dl1d5j821d6p9avf50zb38q26sfa3chzqv2ky4";
                };
            in self.callCabal2nix "reactive-banana-gi-gtk" "${src}/reactive-banana-gi-gtk" {};
          haskell-gi-overloading = dontHaddock (self.callPackage
              ({ mkDerivation, stdenv }:
              mkDerivation {
                pname = "haskell-gi-overloading";
                version = "1.0";
                sha256 = "3ed797f8dd8d3535640b1ca99851bbc5968817c25a80fc499af42715d371682a";
                homepage = "https://github.com/haskell-gi/haskell-gi";
                description = "Overloading support for haskell-gi";
                license = stdenv.lib.licenses.bsd3;
              }){});

      } //
      ( if compiler == "ghc842" || compiler == "ghc843"
        then {
            criterion = super.criterion_1_4_1_0;
            base-compat-batteries = doJailbreak super.base-compat-batteries;
            base-compat = super.base-compat_0_10_1;
          }
        else {}
        ) //
        (let hpkgs = pkgs-ch.haskell.packages.ghc802; in rec {

              # reactive-banana-gi-gtk = self.callPackage (a: hpkgs.reactive-banana-gi-gtks.override (_:a));
              # haskell-gi-base        = self.callPackage (a: hpkgs.haskell-gi-base.override (_:a));
              # gi-gtk                 = self.callPackage (a: hpkgs.gi-gtk.override (_:a));
              # haskell-gi             = self.callPackage (a: hpkgs.haskell-gi.override (_:a));
              # gi-cairo               = self.callPackage (a: hpkgs.gi-cairo.override (_:a));
              # gi-glib                = self.callPackage (a: hpkgs.glib.override (_:a));
              # gi-gio                 = self.callPackage (a: hpkgs.gi-gio.override (_:a));
              # gi-gobject             = self.callPackage (a: hpkgs.gi-gobject.override (_:a));
              # gi-gdkpixbuf           = self.callPackage (a: hpkgs.gi-gdkpixbuf.override (_:a));
              # gi-pango               = self.callPackage (a: hpkgs.gi-pango.override (_:a));
              # gi-gdk                 = self.callPackage (a: hpkgs.gi-gdks.override (_:a));
            })
        ;
    };
  };

    pkgs-18-0-3 =  import (pkgs.fetchgit {
        url= "https://github.com/nixos/nixpkgs-channels";
        rev= "08d245eb31a3de0ad73719372190ce84c1bf3aee";
        sha256= "1g22f8r3l03753s67faja1r0dq0w88723kkfagskzg9xy3qs8yw8";
        fetchSubmodules= true;
      }) {config = {allowUnfree = true;};};

    pkgs-ch = import (pkgs.fetchFromGitHub
        {
          owner = "NixOS";
          repo = "nixpkgs-channels";
          rev = "ade98dc442ea78e9783d5e26954e64ec4a1b2c94";
          sha256 = "1ymyzrsv86mpmiik9vbs60c1acyigwnvl1sx5sd282gndzwcjiyr";
        }) {};
in
{
  nixpkgs.config = {
    packageOverrides = super: rec {
      inherit pkgs-18-0-3;
      taffybar = pkgs-18-0-3.taffybar;
      heroku = (pkgs-18-0-3.callPackage ./heroku-cli {});
      create-react-native-app = (pkgs.callPackage ./create-react-native-app {});
      expo-exp = (pkgs.callPackage ./expo-exp {});
      stack2nix = pkgs.haskell.lib.doJailbreak super.stack2nix;
      haskell = super.haskell // {
        packages = super.haskell.packages //
          (haskellOverrides super.haskell.packages "ghc802")  //
          (haskellOverrides super.haskell.packages "ghc822")  //
          (haskellOverrides super.haskell.packages "ghc842")  //
          (haskellOverrides super.haskell.packages "ghc843")
        ;
      };
      haskellPackages = haskell.packages.ghc822;

      #ghci = ghc821Packages.ghci;
      #ghc = ghc821Packages.ghc;
      #cabal-install = ghc821Packages.cabal-install;

      # teamviewer seem to have removed the files, only latest version 13 is available
      # teamviewer = super.teamviewer.overrideAttrs (old:
      #   rec {
      #     name = "teamviewer-${version}";
      #     version = "12.0.85001";

      #     src = super.fetchurl {
      #       # There is a 64-bit package, but it has no differences apart from Debian dependencies.
      #       # Generic versioned packages (teamviewer_${version}_i386.tar.xz) are not available for some reason.
      #       url = "http://www.shwabob.com/support/tv/v12-Linux/teamviewer_12.0.85001_i386.deb";
      #       sha256 = "01vzky22gisjxa4ihaygkb7jwhl4z9ldd9lli8fc863nxxbrawks";
      #     };
      #   });
      };
    };
}
