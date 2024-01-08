{
  description = "HanStolpo's NixOS systems flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haswaynav = {
      url = "github:hanstolpo/haswaynav";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, kmonad, haswaynav, ... }:
    let
      # helper to apply a function to all entries in a directory
      # loading `name/default.nix`, similar to what import would do,
      # if the entry is a directory
      mapImports = dir: fn: with builtins; with nixpkgs.lib;
        let
          noNulls = filterAttrs (_: v: v != null);

          applyFn = n: v:
            let path = "${toString dir}/${n}"; in
            if v == "directory" && pathExists "${path}/default.nix"
            then nameValuePair n (fn path)
            else if v == "regular" &&
              hasSuffix ".nix" n
            then nameValuePair (removeSuffix ".nix" n) (fn path)
            else nameValuePair "" null
          ;
        in
        noNulls (mapAttrs' applyFn (readDir dir));
    in
    rec {

      # all my custom overlays
      overlays = {
        # we make the unstable packages available to the other overlays / modules
        pkgs-unstable =
          final: prev: {
            pkgs-unstable = import nixpkgs-unstable {
              system = final.system;
              config.allowUnfree = true;
            };
          };
      } // mapImports ./overlays import;



      # expose any custom packages from our overlays to make developing on them easier
      # e.g. you can `nix build ./#<custom_package_name>` to build the derivation
      packages.x86_64-linux = {
        inherit (import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        }) d2 tala realvnc-viewer tree-sitter mdsync swayJournald;
      };

      # my configurations are broken up into modules which the different hosts enable / configure as desired.
      nixosModules = mapImports ./modules import;

      # The configurations for each one of my hosts
      nixosConfigurations =
        let
          hostCommonSetup = { pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            nixpkgs = {
              config.allowUnfree = true;
              overlays = builtins.attrValues self.overlays ++ [ haswaynav.overlays.default kmonad.overlays.default ];
            };

            nix = {
              registry.nixpkgs.flake = nixpkgs;
              settings = {
                sandbox = "relaxed";
              };
              extraOptions = ''
                experimental-features = nix-command flakes recursive-nix
                allow-import-from-derivation = true

                # some defaults as suggested here: https://jackson.dev/post/nix-reasonable-defaults/
                # Almost always set
                connect-timeout = 5
                log-lines = 25
                min-free = 128000000
                max-free = 1000000000

                # Set if understood
                experimental-features = nix-command flakes
                fallback = true
                warn-dirty = false
                auto-optimise-store = true

                # Set for developers
                keep-outputs = true

              '';
            };
          };
          mkHost = host:
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";

              modules =
                builtins.attrValues self.nixosModules ++
                [
                  kmonad.nixosModules.default

                  hostCommonSetup
                  (import host)
                ];
            };
        in
        mapImports ./hosts mkHost;

    };
}
