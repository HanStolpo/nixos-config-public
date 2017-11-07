# actual nix expressions, except for default.nix and
# shell.nix, are generated using node2nix tool by the
# generate.sh script.
#
# The heroku run script requires node to be in its path
# so as post install step add node to the path in the script.
#
# npm fails to install packages when node 8 is used
# but heroku cli requires node 8. So install dependencies
# using node 7 but run the heroku script using node 8.
{pkgs, system, nodejs, nodejs-8_x}:
(import ./heroku-cli.nix {
  inherit pkgs;
  inherit system;
  inherit nodejs;
}).heroku-cli.overrideAttrs (oldAttrs: rec {
    postInstall = ''
      cp $out/bin/heroku $out/bin/heroku-o
      cat $out/bin/heroku-o | head -n 1 > $out/bin/heroku
      echo 'export PATH=${nodejs-8_x}/bin:$PATH' >> $out/bin/heroku
      cat $out/bin/heroku-o | tail -n +2 >> $out/bin/heroku
    '';
})
