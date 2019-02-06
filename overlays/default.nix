self: super:
let


  haskellOverrides = with super.lib.attrsets; with super.haskell.lib; packages: compiler: if !(packages ? "${compiler}") then {} else{

    ${compiler} = let selfPkgs = self; superPkgs = super; in packages.${compiler}.override {
      overrides = self: super:
        let custom = packagesFromDirectory { directory = ./haskell; } self super;
        in
        (filterAttrs (n: v: n != "dbus" && n != "taffybar") custom)
        // {
        taffybar = self.callPackage
          (import ./haskell/taffybar.nix)
          {gtk3 = selfPkgs.gnome3.gtk;};

        #haskell-ide-engine = import ./haskell-ide-engine {pkgs = selfPkgs; haskellCompiler = "ghc802";};
        # we override used by ghc-mod below because it fails its test suite
        #ghc-syb-utils = dontCheck super.ghc-syb-utils;
        #
        xmonad-windownames = doJailbreak super.xmonad-windownames;
        #
        xmonad-extras = doJailbreak super.xmonad-extras;
        #
        #hnix = doJailbreak super.hnix;
        #
        Diff = dontCheck super.Diff;


        # opencv =
        #     let
        #         srcGit =  superPkgs.fetchFromGitHub { owner  = "LumiGuide"; repo   = "haskell-opencv"; rev    = "433abd5dd7d885a04b79e42efb0efcecdb985eed"; sha256 = "0makqxcbmnf02a5xaq6kzfb6lplnchh9dcbknamh32y2iswjdbx3"; };
        #         src = superPkgs.runCommand "opencv-src"
        #           {
        #           }
        #           ''
        #             mkdir -p $out
        #             cp -r ${srcGit}/opencv/*  $out
        #             rm $out/data $out/doc $out/LICENSE
        #             cp -r ${srcGit}/doc     $out/doc
        #             cp -r ${srcGit}/data    $out/data
        #             cp ${srcGit}/LICENSE   $out/LICENSE
        #           '';
        #     in overrideCabal
        #            (self.callCabal2nix "opencv" src {opencv = self.opencv3;})
        #            (_:{
        #              libraryPkgconfigDepends = [ self.opencv3 ];
        #              # remove flags added by cabal2nix `configureFlags = ["--with-gcc=${stdenv.cc}/bin/c++" "--with-ld=${stdenv.cc}/bin/c++"];`
        #              configureFlags = [];
        #            });
        #   #
        #   units-parser = dontCheck super.units-parser;
        #   units = dontCheck super.units;
        #   # hindent = self.callCabal2nix "hindent"
        #   #   (superPkgs.fetchFromGitHub {
        #   #         owner  = "commercialhaskell";
        #   #         repo   = "hindent";
        #   #         rev    = "9cc9ed7f6bd8b16309e61397a0cf88d8df153b29";
        #   #         sha256 = "06syaj5qr0899v0qmmshn3728bxaf4n99d1phh9q21yvlz17j0dn";
        #   #   })
        #   #   {};
        #   descriptive = self.callCabal2nix "descriptive"
        #     (superPkgs.fetchFromGitHub {
        #           owner  = "chrisdone";
        #           repo   = "descriptive";
        #           rev    = "c088960113b2add758553e41cbe439d183b750cd";
        #           sha256 = "17p65ihcvm1ghq23ww6phh8gdj7hwxlypjvh9jabsxvfbp2s8mrk";
        #     })
        #     {};
        #   intero = doJailbreak (dontCheck (self.callCabal2nix "intero"
        #     (superPkgs.fetchFromGitHub {
        #           owner  = "commercialhaskell";
        #           repo   = "intero";
        #           rev    = "b470a806479364bca15de4f7bbba358287174bbd";
        #           sha256 = "01q9sansb50ccjydh65blzcl9b0xaxy09mbjz3481r1qjifnw150";
        #     })
        #     {ghc = self.ghc;}));

        #   reactive-banana-gi-gtk =
        #     let src = superPkgs.fetchFromGitHub {
        #           owner  = "mr";
        #           repo   = "reactive-banana-gi-gtk";
        #           rev    = "18b0b5585762382578f55931feb7332b243d9cd3";
        #           sha256 = "11sns2s53gn8q2dl1d5j821d6p9avf50zb38q26sfa3chzqv2ky4";
        #         };
        #     in self.callCabal2nix "reactive-banana-gi-gtk" "${src}/reactive-banana-gi-gtk" {};
        #   haskell-gi-overloading = dontHaddock (self.callPackage
        #       ({ mkDerivation, stdenv }:
        #       mkDerivation {
        #         pname = "haskell-gi-overloading";
        #         version = "1.0";
        #         sha256 = "3ed797f8dd8d3535640b1ca99851bbc5968817c25a80fc499af42715d371682a";
        #         homepage = "https://github.com/haskell-gi/haskell-gi";
        #         description = "Overloading support for haskell-gi";
        #         license = stdenv.lib.licenses.bsd3;
        #       }){});

        #   #hint =
        #   #  let src = superPkgs.fetchFromGitHub {
        #   #        owner  = "mvdan";
        #   #        repo   = "hint";
        #   #        rev    = "28bb893f54268637c28cdce772a01d6e487e745a";
        #   #        sha256 = "0lpgjfv7b4b1r7smynr8gkg2yvxxn9y8z2nahf7kw6mxs1qp9lda";
        #   #      };
        #   #  in self.callCabal2nix "hint" src {};
      } //
      ( if compiler != "ghc843"
        then {
        }
        else {}
      )//
      ( if compiler == "ghc842" || compiler == "ghc843"
        then {
            cabal-install = super.cabal-install.overrideScope (self: super: { Cabal = null; });
            #cabal-install = super.cabal-install.override(a: {Cabal=null;});
            criterion = super.criterion_1_4_1_0;
            base-compat-batteries = doJailbreak super.base-compat-batteries;
            #base-compat = super.base-compat_0_10_1;
          }
        else {}
        )
         ;
    };
  };

    pkgs-18-0-3 =  import (super.fetchzip {
        url= "https://github.com/NixOS/nixpkgs-channels/archive/5d19e3e78fb89f01e7fb48acc341687e54d6888f.tar.gz";
        sha256= "0vdmbhn5clwny155m21ygjglq3qyi7qki0sbzrb4a1p7sv1yfgp6";
        name = "pkgs-18-0-3";
      }) {config = {allowUnfree = true;};};
in
{
    inherit pkgs-18-0-3;
  #rabbitmq_server = self.pkgs-18-0-3.rabbitmq_server;
  heroku = (self.pkgs-18-0-3.callPackage ./heroku-cli {});
  create-react-native-app = (self.callPackage ./create-react-native-app {});
  expo-exp = (self.callPackage ./expo-exp {});
  stack2nix = self.haskell.lib.doJailbreak super.stack2nix;
  haskell = super.haskell // {
    packages = super.haskell.packages //
      (haskellOverrides super.haskell.packages "ghc802")  //
      (haskellOverrides super.haskell.packages "ghc822")  //
      (haskellOverrides super.haskell.packages "ghc842")  //
      (haskellOverrides super.haskell.packages "ghc843")  //
      (haskellOverrides super.haskell.packages "ghc844")
    ;
  };
  haskellPackages = self.haskell.packages.ghc844;
}
