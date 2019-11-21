import ./default.nix rec {
  system = builtins.currentSystem;
  pkgs = import <nixpkgs> { inherit system; };
  nodejs = pkgs.nodejs;
}
