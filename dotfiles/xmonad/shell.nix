
let
  pkgs = (import <nixpkgs> {
     overlays = [(import ../../overlays)];
  }).pkgs-legacy;
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
     #xmonad-windownames
     xmonad-entryhelper
     taffybar
     dbus
    ]);
in with pkgs;
  # Fake build command for the nix packages if you ever want to make it installable by let say Hydra
  runCommand "adhoc-haskell-env"
    (with haskellPackages;
      rec
        { # this shell hook sets everything up so that the wrapped ghc finds its packages
          shellHook = "eval $(egrep ^export ${ghcWithHoogle}/bin/ghc)";
          # these are all the build time dependencies so they will all be available in the shell
          buildInputs = [
            ghcWithHoogle            # our compiler GHC
            hindent         # a tool for auto formatting Haskell code
            cabal-install   # the Haskell "Package" manager only needed for ghc-mod
            hoogle          # the hoogle Haskell documentation search engine
            hlint           # standalone linter for Haskell code
          ];})
  # the result of the packages is a file with success in it but we are just using the package's
  # build dependencies to get a build environment
  "echo success > $out"
