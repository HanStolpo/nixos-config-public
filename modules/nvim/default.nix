{ pkgs, lib, ... }:
let
  nvim = pkgs.neovim.override {
    # don't alias neovim to vim, yet.
    vimAlias = true;
    withPython3 = true;
    configure = (import ./customization.nix { pkgs = pkgs; });
  };

in
{
  environment.systemPackages =
    [
      nvim
      pkgs.ctags
      pkgs.nixpkgs-fmt
    ];
}
