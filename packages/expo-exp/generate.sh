#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix --pure

echo '["exp"]' > temp
node2nix -i temp -6 --flatten -c exp.nix
rm temp
