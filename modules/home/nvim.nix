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
  ];
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;

    # Runtime dependencies available to neovim (automatically added to PATH)
    extraPackages = runtimeDeps;

    # Load consolidated lua config
    extraLuaConfig = builtins.readFile ../nvim/config.lua;

    # Vimscript config for things that need nix interpolation
    extraConfig = ''
      let g:grammarous#languagetool_cmd = '${pkgs.languagetool}/bin/languagetool-commandline'
    '';

    # Plugins
    plugins = with knownPlugins; [
      nvim-lspconfig
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
      base16-nvim
      nvim-web-devicons
      auto-session
      mini-nvim

      Tabular        # Align text
      extradite      # extends fugitive for git log commit browse
      fugitive       # git integration
      vim-rhubarb    # Gbrowse support for fugitive
      vim-localvimrc
      vim-leader-guide

      coffee-script

      ack-vim        # search with ag

      vim-grammarous
    ];
  };
}
