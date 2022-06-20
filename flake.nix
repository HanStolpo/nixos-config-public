{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    hlissner-dotfiles = {
      url = github:hlissner/dotfiles;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixops = {
      url = github:NixOS/nixops;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, hlissner-dotfiles, nixops, ... }:
    let
      inherit (hlissner-dotfiles.lib) mapModules mapModulesRec';
    in
    rec {
      inherit nixpkgs;

      inherit nixpkgs-unstable;

      overlays = {
        pkgs-unstable =
          final: prev: {
           pkgs-unstable = import nixpkgs-unstable {
             system = final.system;
             config.allowUnfree = true;
         };
        };
      } // mapModules ./overlays import;

      nixosModules = mapModules ./modules import;

      nixosSystems = mapModules ./hosts
        (host: {
          system = "x86_64-linux";
          modules =
            builtins.attrValues self.nixosModules ++
            [
              ({ pkgs, ... }: {
                # Let 'nixos-version --json' know about the Git revision of this flake.
                system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = builtins.attrValues self.overlays;
                };

                nix = {
                  registry.nixpkgs.flake = nixpkgs;
                  useSandbox = "relaxed";
                  package = pkgs.nixFlakes;
                  extraOptions = ''
                    experimental-features = nix-command flakes
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
