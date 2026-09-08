{
  description = "HanStolpo's NixOS systems flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-26.05;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;

    nixpkgs-playwright-pin.url = github:NixOS/nixpkgs/8110df5ad7abf5d4c0f6fb0f8f978390e77f9685;

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haswaynav = {
      url = "github:hanstolpo/haswaynav";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative configuration of the COSMIC desktop environment via home-manager
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-playwright-pin, kmonad, haswaynav, home-manager, stylix, noctalia, niri, cosmic-manager, ... }:
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
              localSystem = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          };
        # we make the nixpkgs-playwright-pin available to the other overlays / modules
        pkgs-playwright-pin =
          final: prev: {
            pkgs-playwright-pin = import nixpkgs-playwright-pin {
              localSystem = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          };
      } // mapImports ./overlays import;



      # expose any custom packages from our overlays to make developing on them easier
      # e.g. you can `nix build ./#<custom_package_name>` to build the derivation
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            stdenv.hostPlatform.system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = builtins.attrValues self.overlays;
          };
        in
        {
          inherit (pkgs) d2 tala realvnc-viewer tree-sitter mdsync swayJournald wtp coderabbit playwright-mcp nordvpn;
          inherit (pkgs.tree-sitter-grammars) tree-sitter-d2;
        };

      # check that our custom packages can still be built
      checks.x86_64-linux = packages.x86_64-linux;

      # my configurations are broken up into modules which the different hosts enable / configure as desired.
      nixosModules = mapImports ./modules import;

      # the nixos system configurations that can be extended
      # from another flake
      nixosSystems =
        let
          hostCommonSetup = { pkgs, config, ... }: {
            # Let 'nixos-version --json' know about the Git revision of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            nixpkgs = {
              hostPlatform = "x86_64-linux";
              config.allowUnfree = true;
              overlays = builtins.attrValues self.overlays ++ [
                haswaynav.overlays.default
                kmonad.overlays.default
                noctalia.overlays.default
                niri.overlays.niri
              ];
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

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inputs = {
                inherit noctalia niri cosmic-manager;
              };
              inherit (config) hanstolpo;
            };
          };
          mkHost = host: {
            modules =
              builtins.attrValues self.nixosModules ++
              [
                kmonad.nixosModules.default

                hostCommonSetup

                home-manager.nixosModules.home-manager

                stylix.nixosModules.stylix

                niri.nixosModules.niri

                (import host)
              ];
          };
        in
        mapImports ./hosts mkHost;


      # The configurations for each one of my hosts
      nixosConfigurations =
        nixpkgs.lib.mapAttrs (_: s: nixpkgs.lib.nixosSystem s) nixosSystems;

    };
}
