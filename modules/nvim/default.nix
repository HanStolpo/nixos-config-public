{ pkgs, lib, ... }:
let
  nvim = pkgs.neovim.override {
    # don't alias neovim to vim, yet.
    vimAlias = true;
    withPython = true;
    withPython3 = true;
    configure = (import ./customization.nix { pkgs = pkgs; });
  };

in
  {
    environment.systemPackages =
    [
      nvim
      pkgs.ctags
      (pkgs.runCommand
        "jailed-haskell-language-server"
        { buildInputs = [ pkgs.makeWrapper ]; }
        ''
          mkdir -p $out/bin
          cp ${./jailed-haskell-language-server.sh} $out/bin/jailed-haskell-language-server
          wrapProgram $out/bin/jailed-haskell-language-server \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.proot ]}
        ''
      )
      pkgs.nixpkgs-fmt
    ];
  }
