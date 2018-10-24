{pkgs ? import <nixpkgs> {}, fetchgit ? pkgs.fetchgit} :

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in with pkgs.rustPlatform.rust;
buildVimPlugin rec {
    name = "LanguageClient-neovim-2017-12-05";
    src = fetchgit {
      url = "https://github.com/autozimu/LanguageClient-neovim";
      rev = "b8fadfd3e43b91437ad6b31550232d28d284ace6";
      sha256 = "0in11g1d0i26n8rj7qgydlfk2r374mx0d67gyvh0bp84np2lh75j";

      #rev = "190bbec8eccd5d851212f1c1dcdd33592ce7c9b1";
      #sha256 = "0b18kspxfvcjyxnrm88yd0qr74jnczxrzq2kqrwp3gqprwamriyh";
    };
    languageclient = builtins.fetchurl "https://github.com/autozimu/LanguageClient-neovim/releases/download/0.1.33/languageclient-0.1.33-x86_64-unknown-linux-musl";
    buildInputs = [ cargo rustc ];
    buildPhase = ''
      cp ${languageclient} ./bin/languageclient
      chmod +x ./bin/languageclient
    '';
    dependencies = [];

}

