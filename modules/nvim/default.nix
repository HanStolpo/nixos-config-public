{ pkgs, lib, ... }:
# let
#   nvim = pkgs.pkgs-unstable.neovim.override {
#     # don't alias neovim to vim, yet.
#     vimAlias = true;
#     withPython3 = true;
#     configure = (import ./customization.nix { pkgs = pkgs.pkgs-unstable; });
#   };
#
# in
# {
#   environment.systemPackages =
#     [
#       nvim
#       pkgs.ctags
#       pkgs.nixpkgs-fmt
#     ];
# }
{
  programs.neovim = {
    enable = true;
    package = pkgs.pkgs-unstable.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;
    configure = {
      customRC = pkgs.callPackage ./vimrc.nix { };
      vam = {
        knownPlugins = pkgs.pkgs-unstable.vimPlugins // pkgs.callPackage ./plugins.nix { };

        pluginDictionaries = [

          { name = "nvim-lspconfig"; }
          { name = "nvim-treesitter"; }
          { name = "telescope-nvim"; }
          { name = "nvim-tree-lua"; }
          { name = "nvim-cmp"; }
          { name = "cmp-nvim-lsp"; }
          { name = "nvim-snippy"; }
          { name = "cmp-snippy"; }
          { name = "hop-nvim"; }
          { name = "diffview-nvim"; }
          { name = "plenary-nvim"; }
          { name = "nerdcommenter"; }
          { name = "lualine-nvim"; }
          { name = "indent-blankline-nvim-lua"; }
          { name = "barbar-nvim"; }
          { name = "nvim-base16"; }
          { name = "nvim-web-devicons"; }
          { name = "auto-session"; }

          { name = "Tabular"; } # Align text
          { name = "extradite"; } # extends fugitive for git log commit browse
          { name = "fugitive"; } # git integration
          { name = "vim-rhubarb"; } # Gbrowse support for fugitive
          { name = "vim-localvimrc"; } #
          { name = "vim-leader-guide"; } # show info about key short cuts

          # color schemes
          #{ name = "vim-colorschemes"; }



          #{ name = "coffee-script"; }


          #{ name = "vim-nix"; }
          #{ name = "elm-vim"; }
          #{ name = "haskell-vim"; }


          #{ name = "vim-autoformat"; }


        ];
      };
    };

  };
}
