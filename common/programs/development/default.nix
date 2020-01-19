{ config, pkgs, ... }:

let
  pathToVim = ../../vim;
  neovimPackages =
    pkgs.callPackage (pathToVim + /neovimPackages.nix) {};

  nix-diff = pkgs.haskellPackages.callPackage (
    import (
      pkgs.fetchgit {
        url = "https://github.com/Gabriel439/nix-diff";
        rev = "e32ffa2c7f38b47a71325a042c1d887fb46cdf7d";
        sha256 = "1k00nx8pannqmpzadkwfrs6bf79yk22ynhd033z5rsyw0m8fcz9k";
        fetchSubmodules = true;
      }
    )
  ) {};
in
{
  environment.systemPackages =
    with pkgs;
    (
      neovimPackages ++ [
        binutils # Tools for manipulating binaries (linker, assembler, etc.)
        ag # A code-searching tool similar to ack, but faster
        ctags # A tool for fast source code browsing (exuberant ctags)
        gnumake # A tool to control the generation of non-source files from sources
        cabal2nix # Convert Cabal files into Nix build instructions
        perl # The standard implementation of the Perl 5 programmming language
        heroku # Everything you need to get started using Heroku
        awscli # Unified tool to manage your AWS services
        nodePackages.node2nix # generate nix from node packages
        #nodejs-7_x
        #create-react-native-app # setup react native app projects
        #expo-exp # command line utility for working with expo client app for react native development

        # source control for configs etc
        gitAndTools.gitFull # git source control
        gitAndTools.gitRemoteGcrypt # encrypted git remotes
        git-crypt


        direnv # automatically setup environment variables when entering a directory
        lorri # maintain development environments based on shell.nix along with direnv (auto reloading quicker entry and gc management)

        nixops

        (haskell.lib.justStaticExecutables haskellPackages.aeson-pretty) # pretty print json text

        # nix-diff

        #(haskell.lib.justStaticExecutables haskellPackages.intero)
        # (haskell.lib.justStaticExecutables haskellPackages.hoogle)
        (haskell.lib.justStaticExecutables haskellPackages.hlint)
        (haskell.lib.justStaticExecutables haskellPackages.hindent)
        # ormolu
        # (haskellPackages.ghcWithHoogle (g: with g;
        #    [# not these libs are actually part of GHC as the core libraries (https://www.haskell.org/platform/contents.html)
        #    array base bytestring Cabal containers deepseq directory filepath
        #    hpc pretty process template-haskell time transformers unix xhtml
        #    # additional haskell platform libraries
        #    async attoparsec call-stack fgl fixed GLURaw GLUT half hashable
        #    haskell-src html HTTP HUnit integer-logarithms mtl network
        #    network-uri ObjectName OpenGL OpenGLRaw parallel parsec primitive
        #    QuickCheck random regex-base regex-compat scientific split StateVar
        #    stm syb text tf-random transformers unordered-containers xhtml zlib
        #    # add any additional libs here
        #    aeson linear lens hspec reactive-banana-gi-gtk opencv
        #    ]))
        # (haskell.lib.justStaticExecutables haskellPackages.cabal-install)

        cargo
        rustc
        #rust_carnix

        jq
        #stack2nix
        xdotool
        stack

        vault

        sqlitebrowser

        gdb # debugger

        gnome3.glade # gtk layout tool

        jq # query json

        firefox-devedition-bin

        graphviz # draw graphs for networks of nodes
        (haskell.lib.justStaticExecutables haskellPackages.ghcide)
        (haskell.lib.justStaticExecutables haskellPackages.hie-bios)
        (haskell.lib.justStaticExecutables haskellPackages.ch-hs-imports)
        (haskell.lib.justStaticExecutables haskellPackages.ch-hs-format)
        ghci-bios

        #yarn2nix
        elm2nix

        nixpkgs-fmt
      ]
    );

  nixpkgs.config = {

    vim = {
      python = true;
      netbeans = false;
      ftNixSupport = true;
    };

    packageOverrides = super:
      {
        vimPlugins = super.vimPlugins // (super.callPackage (pathToVim + /plugins.nix) {});
      };
  };
}
