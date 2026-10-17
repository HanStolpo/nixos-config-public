# Home-manager neovim configuration
{ config, lib, pkgs, ... }:
let
  cfg = config.hanstolpo.nvim;

  # Custom plugins not in nixpkgs
  customPlugins = pkgs.callPackage ../nvim/plugins.nix { };
  knownPlugins = pkgs.vimPlugins // customPlugins;

  # Runtime tools needed by neovim (put on neovim's PATH)
  runtimeDeps = with pkgs; [
    fd
    ripgrep
    difftastic     # difft, used by difftastic-nvim
  ] ++ lib.optionals (!cfg.minimal) [
    python3        # nothing in the config needs it; kept for ad-hoc :!python use
    languagetool   # vim-grammarous (pulls in a JVM)
    tree-sitter    # tree-sitter CLI; grammars themselves come from nix
    clang          # compiling grammars at runtime (:TSInstall), not needed with nix
  ];
in
{
  options.hanstolpo.nvim = {
    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Trim the plugin set and runtime tools to what is useful on a headless
        remote machine. Only plugins that config.lua does not hard-require
        are dropped, so the lua config is shared unchanged.
      '';
    };
  };

  config.programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    viAlias = true;
    # :python3 provider (bundles python + pynvim); no plugin needs it, so skip it remotely
    withPython3 = !cfg.minimal;
    withRuby = false;

    # Runtime dependencies available to neovim (automatically added to PATH)
    extraPackages = runtimeDeps;

    # Load consolidated lua config
    initLua = builtins.readFile ../nvim/config.lua;

    # Vimscript config for things that need nix interpolation
    extraConfig = lib.optionalString (!cfg.minimal) ''
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

      ack-vim        # search with ag
    ] ++ lib.optionals (!cfg.minimal) [
      # Not referenced by config.lua, so safe to leave out remotely
      vim-hoogle
      vim-coffee-script
      vim-grammarous
    ];
  };
}
