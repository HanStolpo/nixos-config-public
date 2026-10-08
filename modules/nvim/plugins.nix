{ pkgs, fetchgit }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
in
{

  "nvim-snippy" = buildVimPlugin {
    name = "nvim-snippy";
    src = fetchgit {
      url = "https://github.com/dcampos/nvim-snippy";
      rev = "4dd4f1146248c0986d3fa6e22e6a31f591b903e9";
      sha256 = "0z9yrwvflsh9nr9a1pk5ja0l5b3ww4lr8q7l26ss4if3csrrs675";
    };
  };

  "cmp-snippy" = buildVimPlugin {
    name = "cmp-snippy";
    src = fetchgit {
      url = "https://github.com/dcampos/cmp-snippy";
      rev = "9af1635fe40385ffa3dabf322039cb5ae1fd7d35";
      sha256 = "1ag31kvd2q1awasdrc6pbbbsf0l3c99crz4h03337wj1kcssiixy";
    };
  };

  "claudecode-nvim" = buildVimPlugin {
    name = "claudecode-nvim";
    src = fetchgit {
      url = "https://github.com/coder/claudecode.nvim";
      rev = "1552086ebcce9f4a2ea3b9793018a884d6b60169";
      sha256 = "0iifa85x5kx36dmwx4ckr70g4z7swy9alz9kksqr4vv7xsgcl4k7";
    };
  };

  # Side-by-side structural diffs via difftastic. Ships a Rust cdylib that the
  # plugin normally downloads or cargo-builds at runtime; build it with nix instead
  # and place it where the lua loader looks (<plugin>/target/release).
  "difftastic-nvim" =
    let
      src = fetchgit {
        url = "https://github.com/clabby/difftastic.nvim";
        rev = "c39bbe1c60eec06ad7d141bd09bb910fac4d2436";
        sha256 = "0fdbbpy3wqz2xp3x3pjyqnll19rp7xmk9vakahq8m5nxhbkyd6n7";
      };
      nativeLib = pkgs.rustPlatform.buildRustPackage {
        pname = "difftastic-nvim-lib";
        version = "0.1.0-unstable-2026-07-09";
        inherit src;
        cargoHash = "sha256-VSlFlLa4knQ7bH8yFHSKTTtt1cQ76dstlCdWBAtkf1I=";
        doCheck = false;
      };
    in
    buildVimPlugin {
      name = "difftastic-nvim";
      inherit src;
      dependencies = [ pkgs.vimPlugins.nui-nvim ];
      postInstall = ''
        mkdir -p $out/target/release
        ln -s ${nativeLib}/lib/libdifftastic_nvim.so $out/target/release/libdifftastic_nvim.so
        # lua requires "difftastic_nvim", so also provide the un-prefixed name
        ln -s ${nativeLib}/lib/libdifftastic_nvim.so $out/target/release/difftastic_nvim.so
      '';
    };

}
