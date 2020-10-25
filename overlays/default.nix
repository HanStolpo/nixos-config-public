self: super:
let
  inherit (super.lib) composeExtensions;

  haskell = super.haskell // {
    packages = builtins.mapAttrs (
      name: value:
        let
          selfPkgs = self;
          superPkgs = super;
          configurations =
            with superPkgs.lib.attrsets;
            with superPkgs.haskell.lib;
            self: super: rec {
              wstunnel = justStaticExecutables (doJailbreak super.wstunnel);
              ch-hs-imports = justStaticExecutables (doJailbreak super.ch-hs-imports);
            };
        in
          value.override {
            overrides =
              composeExtensions
                (superPkgs.haskell.lib.packagesFromDirectory { directory = ./haskell; })
                configurations;
          }
    ) super.haskell.packages;
  };


  fetch-lorri-src = super.fetchgit {
    url = "https://github.com/target/lorri";
    sha256 = "0iw5sv3fs9npli4kviwxzx60qnh7r40shrjpy43plbhlbgdz4q09";
    rev = "3d5eb131a73d72963cb3ee0eee7ac0eca5321254";
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
  haskellPackages = self.haskell.packages.ghc883;

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

  # pulseaudioFull = super.pulseaudioFull.overrideAttrs (
  #   drv:
  #     {
  #       patches = [
  #         # support HFP bluetooth headset like my phillips
  #         # https://wiki.archlinux.org/index.php/Bluetooth_headset#HFP_not_working_with_PulseAudio
  #         # https://freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Bluetooth/#hsphfp
  #         # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/94
  #         (
  #           super.fetchurl
  #             {
  #               url = https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/94.patch;
  #               sha256 = "13b916dkk4ywmjx8kyywszdvdirjv5slh2kms897bjqzy4sa9i8g";
  #             }
  #         )
  #       ];
  #     }
  # );

} // ((import ./ghci-bios) self super)
