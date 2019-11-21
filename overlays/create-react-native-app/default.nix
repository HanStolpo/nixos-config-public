# actual nix expressions, except for default.nix and
# shell.nix, are generated using node2nix tool by the
# generate.sh script.
#
{ pkgs, system, nodejs }:
(
  import ./create-react-native-app.nix {
    inherit pkgs;
    inherit system;
    inherit nodejs;
  }
).create-react-native-app
