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
    #  # from pkgs.vimPlugins
    #  #{ name = "youcompleteme"; }       # symbol completion
    #  { name = "deoplete-nvim";}
      { name = "vim-airline"; }         # Status line
    #  #{ name = "command-t"; }           # Fuzzy file finder
      { name = "ctrlp-vim"; }          # Fuzzy file finder
      { name = "vim-easy-align";}       # Align text
      { name = "Tabular";}              # Align text
      { name = "vim-easymotion";}       # smarter motions
      { name = "The_NERD_Commenter";}   # Comment uncomment
      { name = "The_NERD_tree";}        # File tree explorer
    #  #{ name = "vim-stylish-haskell";}  # File tree explorer
      { name = "Gist";}                 # create github gists automatically
      { name = "Tagbar";}               # Side bar to browse current tags
      #{ name = "YankRing";}             # copy history
      { name = "extradite";}            # extends fugitive for git log commit browse
      { name = "fugitive";}             # git integration
      { name = "rhubarb.vim";}          # Gbrowse support for fugitive
      #{ name = "vim-autoformat";}       # Auto format using several different formatters
      { name = "vim-localvimrc";}       #
      { name = "vim-leader-guide";}     # show info about key short cuts
      #{ name = "tslime-vim";}           # Send text to tmux session
      { name = "vimproc-vim";}          # Run processes in background
      { name = "table-mode";}           #
      { name = "ipython";}              #

      # Type script related
      { name = "typescript-vim";}              #
      { name = "tsuquyomi";}              #

      # { name = "vimpreviewpandoc";}     # Run processes in background


      #{ name = "neomake";}              # Build and error highlighting support
      #{ name = "syntastic"; }
      { name = "vim-ale"; }

      # color schemes
      { name = "vim-colorschemes";}

      # file type
      #{ name = "vim-polyglot";}         # highlighting for all filetypes (custom)
      # haskell
      #{ name = "neco-ghc";}
      { name = "hlint-refactor-vim";}
      # Pure script
      { name = "psc-ide-vim";}

      { name = "coffee-script";}


      { name = "vim-nix"; }
      { name = "elm-vim"; }
      #{ name = "vim-hdevtools"; }
      { name = "haskell-vim"; }
      #{ name = "LanguageClient-neovim"; }

      { name = "clang_complete"; }
      #{ name = "vim-clang-format"; }

      # from our own plugin package set
      { name = "vim-trailing-whitespace"; }
      { name = "vim-yankstack"; }
      { name = "vim-scratch"; }
      #{ name = "vim-session"; }
      { name = "vimpager"; }
      { name = "vim-ag";}
      #{ name = "vim-intero";}
      #{ name = "vim-reason-plus";}
      #{ name = "intero-neovim";}

      { name = "base16-vim";}

      { name = "vim-textobj-haskell";}

      { name = "vim-textobj-user";}

    ];
  };
}
