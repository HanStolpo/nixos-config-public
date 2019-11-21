{ pkgs }:

let
  # this is the vimrc.nix from above
  vimrc   = pkgs.callPackage ./vimrc.nix {};

  # and the plugins.nix from above
  plugins = pkgs.callPackage ./plugins.nix {};
in
{
  customRC = vimrc;
  vam = {
    knownPlugins = pkgs.vimPlugins // plugins;

    pluginDictionaries = [
      { name = "vim-airline"; }         # Status line
      { name = "ctrlp-vim"; }          # Fuzzy file finder
      { name = "vim-easy-align";}       # Align text
      { name = "Tabular";}              # Align text
      { name = "vim-easymotion";}       # smarter motions
      { name = "The_NERD_Commenter";}   # Comment uncomment
      { name = "The_NERD_tree";}        # File tree explorer
      { name = "Gist";}                 # create github gists automatically
      { name = "Tagbar";}               # Side bar to browse current tags
      { name = "extradite";}            # extends fugitive for git log commit browse
      { name = "fugitive";}             # git integration
      { name = "vim-rhubarb";}          # Gbrowse support for fugitive
      { name = "vim-localvimrc";}       #
      { name = "vim-leader-guide";}     # show info about key short cuts
      { name = "vimproc-vim";}          # Run processes in background
      { name = "table-mode";}           #
      { name = "ipython";}              #

      # Type script related
      { name = "typescript-vim";}              #
      { name = "tsuquyomi";}              #

      { name = "ale"; }
      { name = "vim-ale-ghcide"; }

      # color schemes
      { name = "vim-colorschemes";}

      { name = "hlint-refactor-vim";}

      # Pure script
      { name = "psc-ide-vim";}

      { name = "coffee-script";}


      { name = "vim-nix"; }
      { name = "elm-vim"; }
      { name = "haskell-vim"; }

      { name = "clang_complete"; }

      # from our own plugin package set
      { name = "vim-trailing-whitespace"; }
      { name = "vim-yankstack"; }
      { name = "vim-scratch"; }
      { name = "vim-ag";}

      { name = "base16-vim";}

      { name = "vim-textobj-haskell";}

      { name = "vim-textobj-user";}

      { name = "vim-jade";}

      { name = "Improved-AnsiEsc";}

      { name = "vim-autoformat";}
    ];
  };
}
