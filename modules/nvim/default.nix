{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;

    runtime = with builtins;
      listToAttrs (
        map (tsName:
          let l = lib.strings.removePrefix "tree-sitter-" tsName;
              grammar = pkgs.tree-sitter-grammars."${tsName}";
          # Only directories under 'etc' are added to the runtime path this is probably a mistake but oh well
          # https://github.com/NixOS/nixpkgs/blob/e0a42267f73ea52adc061a64650fddc59906fc99/nixos/modules/programs/neovim.nix#L161
          in { name = "etc/parser/${l}.so";
               value = {
                  source = "${grammar}/parser";
                };
             }
          )
          ( filter (lib.strings.hasPrefix "tree-sitter-") (attrNames pkgs.tree-sitter-grammars) )
      );

    configure = {
      customRC = pkgs.callPackage ./vimrc.nix { };
      vam = {
        knownPlugins = pkgs.vimPlugins // pkgs.callPackage ./plugins.nix { };

        pluginDictionaries = [

          { name = "nvim-lspconfig"; }
          { name = "nvim-lint"; }
          { name = "nvim-treesitter"; }
          { name = "telescope-nvim"; }
          { name = "nvim-tree-lua"; }
          { name = "nvim-snippy"; }
          { name = "hop-nvim"; }
          { name = "diffview-nvim"; }
          { name = "plenary-nvim"; }
          { name = "nerdcommenter"; }
          { name = "lualine-nvim"; }
          #{ name = "indent-blankline-nvim-lua"; }
          { name = "barbar-nvim"; }
          { name = "nvim-base16"; }
          { name = "nvim-web-devicons"; }
          { name = "auto-session"; }
          { name = "mini-nvim"; }

          { name = "Tabular"; } # Align text
          { name = "extradite"; } # extends fugitive for git log commit browse
          { name = "fugitive"; } # git integration
          { name = "vim-rhubarb"; } # Gbrowse support for fugitive
          { name = "vim-localvimrc"; } #
          { name = "vim-leader-guide"; } # show info about key short cuts

          { name = "coffee-script"; } # show info about key short cuts

          { name = "ack-vim" ;} # instead of silver searcher `ag` which is deprecate. https://github.com/rking/ag.vim/issues/124#issuecomment-227038003

          { name = "vim-grammarous"; }

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
