final: prev: {
  #nix = prev.nixFlakes;
  # inherit (final.pkgs-unstable) nix-du;
  nix = final.pkgs-unstable.nixFlakes;
  inherit (final.pkgs-unstable) nix-du nixFlakes;
  # # inherit (final.pkgs-unstable)
  # #   nix nixFlakes nix-du nix-prefetch-scripts patchelf nix-index nixops nixpkgs-fmt;
}
