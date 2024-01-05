{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    hlissner-dotfiles = {
      url = github:hlissner/dotfiles;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haswaynav = {
      url = "github:hanstolpo/haswaynav";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, hlissner-dotfiles, flake-utils, kmonad, haswaynav, ... }:
    let
      inherit (hlissner-dotfiles.lib) mapModules mapModulesRec';
      inherit (flake-utils.lib) eachSystem allSystems;
    in
    rec {

      overlays = {
        pkgs-unstable =
          final: prev: {
            pkgs-unstable = import nixpkgs-unstable {
              system = final.system;
              config.allowUnfree = true;
            };
          };
        haswaynav =
          final: prev: {
            haswaynav = haswaynav.defaultPackage."${final.system}";
          };
      } // mapModules ./overlays import;



      packages.x86_64-linux = {
        inherit (import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        }) d2 tala realvnc-viewer tree-sitter mdsync swayJournald;
      };

      nixosModules = mapModules ./modules import;

      nixosSystems = mapModules ./hosts
        (host: {
          system = "x86_64-linux";
          modules =
            builtins.attrValues self.nixosModules ++
            [
              kmonad.nixosModules.default

              ({ pkgs, ... }: {
                # Let 'nixos-version --json' know about the Git revision of this flake.
                system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = builtins.attrValues self.overlays ++ [ kmonad.overlays.default ];
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
              })
              (import host)
            ];
        });

      nixosConfigurations =
        nixpkgs.lib.attrsets.mapAttrs
          (_: v: nixpkgs.lib.nixosSystem v)
          self.nixosSystems
      ;
    };
}
