{ config, pkgs, ... }:

let
   pathToVim = ../../vim;
   neovimPackages =
     pkgs.callPackage (pathToVim + /neovimPackages.nix) {};
in
{
  environment.systemPackages =
  with pkgs;
  (neovimPackages ++
  [
     binutils # Tools for manipulating binaries (linker, assembler, etc.)
     haskellPackages.aeson-pretty # json pretty printer
     ag # A code-searching tool similar to ack, but faster
     ctags # A tool for fast source code browsing (exuberant ctags)
     gnumake # A tool to control the generation of non-source files from sources
     cabal2nix # Convert Cabal files into Nix build instructions
     perl # The standard implementation of the Perl 5 programmming language
     heroku # Everything you need to get started using Heroku
     awscli # Unified tool to manage your AWS services
     nodePackages.node2nix # generate nix from node packages
     #nodejs-7_x
     create-react-native-app # setup react native app projects
     expo-exp # command line utility for working with expo client app for react native development

    # source control for configs etc
     gitAndTools.gitFull # git source control
     gitAndTools.gitRemoteGcrypt # encrypted git remotes
     git-crypt

     stack2nix

     # haskell.compiler.ghc821
     # haskell.packages.ghc821.cabal-install
     # haskell.packages.ghc821.hdevtools
     # haskell.packages.ghc821.hlint

     direnv # automatically setup environment variables when entering a directory

     nixops

     haskellPackages.aeson-pretty # pretty print json text
  ]);

  nixpkgs.config = {

    vim = {
      python = true;
      netbeans = false;
      ftNixSupport = true;
    };

    packageOverrides = super:
    {
      vimPlugins = super.vimPlugins // (super.callPackage (pathToVim + /plugins.nix) {});
      heroku = (pkgs.callPackage ../../../packages/heroku-cli {}).heroku-cli;
      create-react-native-app = (pkgs.callPackage ../../../packages/create-react-native-app {}).create-react-native-app;
      expo-exp = (pkgs.callPackage ../../../packages/expo-exp {}).exp;
    };
  };
}
