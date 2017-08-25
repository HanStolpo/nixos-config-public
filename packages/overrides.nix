{ config, pkgs, ... }:

{
  nixpkgs.config = {

    packageOverrides = super:
    {
      heroku = (pkgs.callPackage ./heroku-cli {});
      create-react-native-app = (pkgs.callPackage ./create-react-native-app {});
      expo-exp = (pkgs.callPackage ./expo-exp {});
    };
  };
}
