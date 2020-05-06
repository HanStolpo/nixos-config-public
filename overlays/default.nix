self: super:
let

  haskell = super.haskell // {
    packages = builtins.mapAttrs (
      name: value:
        let
          selfPkgs = self;
          superPkgs = super;
        in
          value.override {
            overrides =
              with superPkgs.lib.attrsets;
              with superPkgs.haskell.lib;
              self: super: {

                wstunnel = justStaticExecutables (doJailbreak (self.callPackage ./haskell/wstunnel.nix {}));

                hie-bios = self.callPackage (import ./haskell/hie-bios.nix) {};
                ch-hs-imports =
                  doJailbreak (
                    self.callPackage (import ./haskell/ch-hs-imports.nix) {}
                  );

              };
          }
    ) super.haskell.packages;
  };


  fetch-lorri-src = super.fetchgit {
    url = "https://github.com/target/lorri";
    sha256 = "0rkga944jl6i0051vbsddfqbvzy12168cbg4ly2ng1rk0x97dbr8";
    rev = "7b84837b9988d121dd72178e81afd440288106c5";
    fetchSubmodules = false;
  };
  lorri-nixpkgs =
    import
      (builtins.toPath "${fetch-lorri-src}/nix/nixpkgs.nix");
  lorri =
    self.callPackage
      (builtins.toPath "${fetch-lorri-src}/default.nix") {
      src = (builtins.toPath "${fetch-lorri-src}");
      pkgs = lorri-nixpkgs;
    };
in
rec {

  inherit lorri;


  #prettier = self.yarn2nix-moretea.mkYarnPackage rec{
  #name = "prettier";
  #src = super.fetchFromGitHub {
  #owner = "prettier";
  #repo = "prettier";
  #rev = "a858a315e926c21bd1ebfcde70a08419c9472a8c";
  #sha256 = "1rwxdxadj541cvgahmyppqchqz9pmhhc1rqxg62m7hk1gvvvly5d";
  #};
  #packageJSON = "${src}/package.json";
  #yarnLock = "${src}/yarn.lock";
  ## NOTE: this is optional and generated dynamically if omitted
  ##yarnNix = ./yarn.nix;
  #};

  realvnc-viewer = self.callPackage ./realvnc-viewer {};
  create-react-native-app = (self.callPackage ./create-react-native-app {});
  expo-exp = (self.callPackage ./expo-exp {});
  stack2nix = self.haskell.lib.doJailbreak super.stack2nix;
  inherit haskell;

  mykicad = super.kicad.overrideAttrs (
    oldAttrs: rec {
      name = "mikicad";
      src = super.fetchFromGitHub {
        owner = "KICad";
        repo = "kicad-source-mirror";
        rev = "d132cf37e0e08a83b16820f6e04757b7d3753548";
        sha256 = "1rj78y9ix89jbql12l25rm0pjwjswmyxkvr4461y1sf26ydla823";
      };
    }
  );

  slack = self.callPackage ./slack { gdk-pixbuf = self.gdk_pixbuf; };

} // ((import ./ghci-bios) self super)
