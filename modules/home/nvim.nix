# Home-manager neovim configuration
{ pkgs, ... }:
let
  # Custom plugins not in nixpkgs
  customPlugins = pkgs.callPackage ../nvim/plugins.nix { };
  knownPlugins = pkgs.vimPlugins // customPlugins;

  # Runtime tools needed by neovim
  runtimeDeps = with pkgs; [
    nodejs
    python3
    fd
    ripgrep
    languagetool
    tree-sitter
    clang
    difftastic     # difft, used by difftastic-nvim
  ];
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;
    withRuby = false;

    # Runtime dependencies available to neovim (automatically added to PATH)
    extraPackages = runtimeDeps;

    # Load consolidated lua config
    initLua = builtins.readFile ../nvim/config.lua;

    # Vimscript config for things that need nix interpolation
    extraConfig = ''
      let g:grammarous#languagetool_cmd = '${pkgs.languagetool}/bin/languagetool-commandline'
    '';

    # Plugins
    plugins = with knownPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withPlugins (p: with p; [
        bash c cpp cmake css dockerfile elm fish
        diff git_config git_rebase gitattributes gitcommit gitignore
        haskell html javascript json lua make
        markdown markdown_inline nix python query regex rust scss sql
        toml tsx typescript vim vimdoc yaml
      ]))
      telescope-nvim
      nvim-tree-lua
      nvim-snippy
      hop-nvim
      diffview-nvim
      diffs-nvim     # treesitter-powered diff highlighting, :Gdiff / :Greview
      neogit         # magit-like git UI
      difftastic-nvim # side-by-side structural diffs (:Difft)
      plenary-nvim
      nerdcommenter
      lualine-nvim
      barbar-nvim
      base16-nvim
      nvim-web-devicons
      auto-session
      mini-nvim

      tabular        # Align text
      vim-extradite  # extends fugitive for git log commit browse
      vim-fugitive   # git integration
      vim-rhubarb    # Gbrowse support for fugitive
      vim-localvimrc
      vim-leader-guide

      vim-hoogle

      vim-coffee-script

      ack-vim        # search with ag

      vim-grammarous
    ];
  };
}
