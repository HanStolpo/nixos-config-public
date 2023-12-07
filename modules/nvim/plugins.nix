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

  }
