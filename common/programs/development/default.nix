{ config, pkgs, ... }:

let
   # See https://github.com/NixOS/nixpkgs/pull/25983 for work in progress
   heroku_custom = pkgs.callPackage
     (pkgs.fetchurl {
       url = "https://raw.githubusercontent.com/shosti/nixpkgs/e60ed33920aa4309623a4f2bb07811ed837e244d/pkgs/development/tools/heroku/default.nix";
       sha256 = "1jzakz4psj0lpcqj8mqg78jjwmm3mrym990s69m5kjqacysxkxb6";}
     ) {};
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
     heroku_custom # Everything you need to get started using Heroku
     awscli # Unified tool to manage your AWS services
     nodePackages.node2nix
     nodejs-8_x

    # source control for configs etc
     gitAndTools.gitFull # git source control
     gitAndTools.gitRemoteGcrypt # encrypted git remotes
     git-crypt
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
    };
  };
}
