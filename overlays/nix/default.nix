final: prev: {
  nix = prev.nixVersions.nix_2_17;
  #inherit (final.pkgs-unstable) nix-du nix-prefetch-scripts nix-index nixpkgs-fmt;
}
