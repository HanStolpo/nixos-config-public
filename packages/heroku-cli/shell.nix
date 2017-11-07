import ./default.nix rec {
    system = builtins.currentSystem;
    pkgs = import <nixpkgs> {inherit system;};
    nodejs = pkgs.nodejs;
    nodejs-8_x = pkgs.nodejs-8_x;
}
