{ pkgs, lib, ... }:
let neovimPkgs = pkgs.pkgs-unstable;
in
{
  programs.neovim = {
    enable = true;
    package = neovimPkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;

    runtime = with builtins;
      listToAttrs (
        concatMap (tsName:
          if tsName == "tree-sitter-nix"
            then
              []
          else
          let l = lib.strings.removePrefix "tree-sitter-" tsName;
              grammar = neovimPkgs.tree-sitter-grammars."${tsName}";
          # Only directories under 'etc' are added to the runtime path this is probably a mistake but oh well
          # https://github.com/NixOS/nixpkgs/blob/e0a42267f73ea52adc061a64650fddc59906fc99/nixos/modules/programs/neovim.nix#L161
          in [{ name = "etc/parser/${l}.so";
               value = {
                  source = "${grammar}/parser";
                };
              }
              # https://github.com/nvim-treesitter/nvim-treesitter#adding-queries
              { name = "etc/queries/${l}";
               value = {
                  source = "${grammar}/queries";
                };
              }
             ]
          )
          ( filter (lib.strings.hasPrefix "tree-sitter-") (attrNames neovimPkgs.tree-sitter-grammars) )
      );

    configure = 
      let  knownPlugins = neovimPkgs.vimPlugins // pkgs.callPackage ./plugins.nix { };
      in {
      customRC = pkgs.callPackage ./vimrc.nix { inherit (neovimPkgs) tree-sitter; };
      packages.myVimPackage = with knownPlugins; {
        # loaded on launch
        start = [
          nvim-lspconfig
          nvim-lint
          nvim-treesitter
          telescope-nvim
          nvim-tree-lua
          nvim-snippy
          hop-nvim
          diffview-nvim
          plenary-nvim
          nerdcommenter
          lualine-nvim
          barbar-nvim
          nvim-base16
          nvim-web-devicons
          auto-session
          mini-nvim

          Tabular # Align text
          extradite # extends fugitive for git log commit browse
          fugitive # git integration
          vim-rhubarb # Gbrowse support for fugitive
          vim-localvimrc #
          vim-leader-guide # show info about key short cuts

          coffee-script # show info about key short cuts

          ack-vim # instead of silver searcher `ag` which is deprecate. https://github.com/rking/ag.vim/issues/124#issuecomment-227038003

          vim-grammarous

        ];
         # manually loadable by calling `:packadd $plugin-name`
         opt = [ ];
       };
     };

  };
}
