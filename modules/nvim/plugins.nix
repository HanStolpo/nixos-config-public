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
      rev = "9c74ead26b73b627368d57e7c4032e465911b514";
      sha256 = "1l51slqg1yzfr55xp5n6p6hbs9mikga0rsbdzbx3i39qra3mkf4p";
    };
  };

}
