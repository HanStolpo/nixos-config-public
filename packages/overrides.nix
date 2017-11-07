{ pkgs, ... }:

{
  nixpkgs.config = {
    packageOverrides = super:
    let ghc821Packages = super.haskell.packages.ghc821.override {
            overrides = self: super: {
              hdevtools = self.callPackage (
                { mkDerivation, base, Cabal, cmdargs, directory, fetchgit, filepath
                , ghc, ghc-boot, ghc-paths, network, process, stdenv, syb, time
                , transformers, unix
                }:
                mkDerivation {
                  pname = "hdevtools";
                  version = "0.1.6.0";
                  src = fetchgit {
                    url = "https://github.com/hdevtools/hdevtools";
                    sha256 = "0mvgffk00rnxcza7bdr1p87p6ljjbfx5ppg60w9rym1lxabrg4by";
                    rev = "bc2c8f70f091f838bac1b5792dd600f5e3850386";
                  };
                  isLibrary = false;
                  isExecutable = true;
                  executableHaskellDepends = [
                    base Cabal cmdargs directory filepath ghc ghc-boot ghc-paths
                    network process syb time transformers unix
                  ];
                  homepage = "https://github.com/hdevtools/hdevtools/";
                  description = "Persistent GHC powered background server for FAST haskell development tools";
                  license = stdenv.lib.licenses.mit;
                }
              ) {};
            };
          };
    in {
      heroku = (pkgs.callPackage ./heroku-cli {});
      create-react-native-app = (pkgs.callPackage ./create-react-native-app {});
      expo-exp = (pkgs.callPackage ./expo-exp {});
      stack2nix = pkgs.haskell.lib.doJailbreak super.stack2nix;
      haskell = super.haskell // {
        packages = super.haskell.packages // {ghc821 = ghc821Packages;};
        };
      #haskellPackages = ghc821Packages;
      #ghci = ghc821Packages.ghci;
      #ghc = ghc821Packages.ghc;
      #cabal-install = ghc821Packages.cabal-install;
      };
    };
}
