
let
  pkgs = import <nixpkgs>
  # following the newer more correct way to override a package
  # see set http://nixos.org/nixpkgs/manual/#chap-overlays
  { overlays = [
      (self: super:
        {
          # override any haskell packages from the imported package
          # that we want to modify see http://nixos.org/nixpkgs/manual/#how-to-build-projects-that-depend-on-each-other
          haskellPackages = super.haskellPackages.override {
              # a bunch of convenience function for working with haskell are defined
              # <nixpkgs>.haskell.lib see https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/haskell-modules/lib.nix
              overrides = self: super: with pkgs.haskell.lib; {
                # we override used by ghc-mod below because it fails its test suite
                ghc-syb-utils = dontCheck super.ghc-syb-utils;
                #
                xmonad-windownames = pkgs.haskell.lib.doJailbreak super.xmonad-windownames;
            };};
        })
    ];
  };
  # setup a GHC with the packages you want
  # they will be built with documentation and a local hoogle
  # search engine too for searching documentation
  # to run a local documentation server do the following command from this directory
  # nix-shell --run "hoogle server --port 8000"
  ghcWithHoogle =
    pkgs.haskellPackages.ghcWithHoogle (g: with g;
    [# not these libs are actually part of GHC as the core libraries (https://www.haskell.org/platform/contents.html)
    array base bytestring Cabal containers deepseq directory filepath
    hpc pretty process template-haskell time transformers unix xhtml
    # additional haskell platform libraries
    async attoparsec call-stack fgl fixed GLURaw GLUT half hashable
    haskell-src html HTTP HUnit integer-logarithms mtl network
    network-uri ObjectName OpenGL OpenGLRaw parallel parsec primitive
    QuickCheck random regex-base regex-compat scientific split StateVar
    stm syb text tf-random transformers unordered-containers xhtml zlib
    # add any additional libs here
     xmobar
     xmonad
     xmonad-contrib
     xmonad-extras
     xmonad-utils
     xmonad-windownames
     xmonad-entryhelper
     taffybar
     dbus
    ]);
in with pkgs;
  # Fake build command for the nix packages if you ever want to make it installable by let say Hydra
  runCommand "adhoc-haskell-env"
    (with ghcWithHoogle.haskellPackages;
      rec
        { # this is not really needed but ghc is used in the buildInputs and shell hook below
          ghc = ghcWithHoogle;
          # this shell hook sets everything up so that the wrapped ghc finds its packages
          shellHook = "eval $(egrep ^export ${ghc}/bin/ghc)";
          # these are all the build time dependencies so they will all be available in the shell
          buildInputs =
          [ghc            # our compiler GHC
          ghc-mod         # a tool to syntax check an lint Haskell code usable from emacs vim etc
                          # you can e.g. run `nix-shell --run "ghc-mod lint filename.hs" to lint your a file
          hindent         # a tool for auto formatting Haskell code
          cabal-helper    # a tool used by ghc-mod to find the cabal-install program
          cabal-install   # the Haskell "Package" manager only needed for ghc-mod
          hoogle          # the hoogle Haskell documentation search engine
          hlint           # standalone linter for Haskell code
          hdevtools       # a tool that runs in the background continuously checking your Haskell
                          # code for errors and is usable from emac, vim, other editors
          xmonad-with-packages
          ];})
  # the result of the packages is a file with success in it but we are just using the package's
  # build dependencies to get a build environment
  "echo success > $out"
