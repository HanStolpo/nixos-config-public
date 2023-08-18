final: prev: {
  #nix = prev.nixFlakes;
  # inherit (final.pkgs-unstable) nix-du;
  nix = final.pkgs-unstable.nixVersions.nix_2_16;
  inherit (final.pkgs-unstable) nix-du nix-prefetch-scripts nix-index nixpkgs-fmt;
}
