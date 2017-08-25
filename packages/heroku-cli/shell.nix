import ./default.nix rec {
    system = builtins.currentSystem;
    pkgs = import <nixpkgs> {inherit system;};
    nodejs-7_x = pkgs.nodejs-7_x;
    nodejs-8_x = pkgs.nodejs-8_x;
}
