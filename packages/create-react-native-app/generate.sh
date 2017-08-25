#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix --pure

echo '["create-react-native-app"]' > temp
node2nix -i temp -6 --flatten -c create-react-native-app.nix
rm temp
