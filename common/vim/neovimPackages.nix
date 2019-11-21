{ pkgs, lib, ... }:

let
  nvim = pkgs.neovim.override {
    # don't alias neovim to vim, yet.
    vimAlias = true;
    withPython = true;
    withPython3 = true;
    configure = (import ./customization.nix { pkgs = pkgs; });
  };

in
[
  nvim
  pkgs.python35Full
  pkgs.python35
  pkgs.ctags
]
