{pkgs, fetchgit} :

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {

  "vim-yankstack" = buildVimPlugin {
    name = "vim-yankstack";
    src = fetchgit {
      url = "https://github.com/maxbrunsfeld/vim-yankstack";
      rev = "157a659c1b101c899935d961774fb5c8f0775370";
      sha256 = "17syazm2jvksfhz2zfkb5b5snbmkxffskrjkp6jgrsh52lxiy4wl";
    };
  };

 "vim-scratch" = buildVimPlugin {
   name = "vim-scratch";
   src = fetchgit {
     url = "https://github.com/duff/vim-scratch";
     rev = "96f2e92a187948d20c97ce705a2f863507234f99";
     sha256 = "02223q6gazr6hb827gc6hq8sbhjk87r232ji60rbjl3qhcim9bdg";
   };
 };

 "vim-session" = buildVimPlugin {
   name = "vim-session";
   src = fetchgit {
     url = "https://github.com/xolox/vim-session";
     rev = "9e9a6088f0554f6940c19889d0b2a8f39d13f2bb";
     sha256 = "0000000000000000000000000000000000000000000000000000";
   };
 };

  "vimpager" = buildVimPlugin {
    name = "vimpager";
    src = fetchgit {
      url = "https://github.com/rkitover/vimpager";
      rev = "cce12a43d5d2f034de1d603b33cadd19dc0c9c02";
      sha256 = "090zvsywh9nzawly6xaa3za4nnz1gv7mgkkilkplwslqa08c1y9f";
    };
  };

  "vim-trailing-whitespace" = buildVimPlugin {
      name = "vim-trailing-whitespace";
      src = fetchgit {
        url = "https://github.com/bronson/vim-trailing-whitespace";
        rev = "d4ad27de051848e544e360482bdf076b154de0c1";
        sha256 = "1xrx9c8d4qwf38jc44a9szw195m8rfri9bsdcj701p9s9ral0l31";
      };
      dependencies = [];
    };

  "vim-ag" = buildVimPlugin {
      name = "vim-ag";
      src = fetchgit {
        url = "https://github.com/rking/ag.vim";
        rev = "4a0dd6e190f446e5a016b44fdaa2feafc582918e";
        sha256 = "1dz7rmqv3xw31090qms05hwbdfdn0qd1q68mazyb715cg25r85r2";
      };
      dependencies = [];
    };
  "vim-intero" = buildVimPlugin {
      name = "vim-ag";
      src = fetchgit {
        url = "https://github.com/myfreeweb/intero.nvim";
        rev = "2ab44a0dd4d34bc7c210b8b7db8b01a28827a28f";
        sha256 = "1rycsppq5m06bqnd4zi9k969iapddf7yq1dnaphpzf1zj710pbzx";
      };
      dependencies = [];
    };
  "vim-ale" = buildVimPlugin {
      name = "vim-ale";
      src = fetchgit {
        url = "https://github.com/w0rp/ale";
        rev = "2000436dfd7a25a8e9f66788c94bfb4512adda98";
        sha256 = "173ha2z9i2ma3iyrgy97a06xkaa7igq58rka4z585rbdza6vw8gk";
      };
      dependencies = [];
    };

  "vim-clang-format" = buildVimPlugin {
      name = "vim-clang-format";
      src = fetchgit {
        url = "https://github.com/rhysd/vim-clang-format";
        rev = "95051583232fb9ad27d55e417b6ffc3933c50738";
        sha256 = "1057d5mm059bjw6zcpn8w3ps3ziz8nwmirdmxdzm6fmfnrrgmzc7";
      };
      dependencies = [];
    };
  "vim-reason-plus" = buildVimPlugin {
      name = "vim-reason-plus";
      src = fetchgit {
        url = "https://github.com/reasonml-editor/vim-reason-plus";
        rev = "91138fa3ff985a89b0c863d1ff389b40ff6c28c9";
        sha256 = "169nmcwwskr9m1b7f0p8d0c8l2k9yhblb868w2n6vv3wjjamg7sd";
      };
      dependencies = [];
    };

  "rhubarb.vim" = buildVimPlugin {
      name = "rhubarb.vim";
      src = fetchgit {
        url = "https://github.com/tpope/vim-rhubarb";
        rev = "e57ed3b6be2c4a49656f1a816919f0af22fae324";
        sha256 = "0g60prwfjc3mn1vq69ki8qcqcny952zpm3idq9x9l45iddfpihcr";
      };
      dependencies = [];
    };

  "intero-neovim" = buildVimPlugin {
      name = "intero-neovim";
      src = fetchgit {
        url = "https://github.com/parsonsmatt/intero-neovim";
        rev = "51999e8abfb096960ba0bc002c49be1ef678e8a9";
        sha256 = "1igc8swgbbkvyykz0ijhjkzcx3d83yl22hwmzn3jn8dsk6s4an8l";
      };
      dependencies = [];
    };

  LanguageClient-neovim = import ./LanguageClient-neovim.nix {inherit pkgs fetchgit;};

  "base16-vim" = buildVimPlugin {
      name = "base16-vim";
      src = fetchgit {
        url = "https://github.com/chriskempson/base16-vim";
        rev = "fcce6bce6a2f4b14eea7ea388031c0aa65e4b67d";
        sha256 = "0wi8k80v2brmxqbkk0lrvl4v2sslkjfwpvflm55b3n0ii8qy39nk";
      };
      dependencies = [];
    };

  "vim-textobj-haskell" = buildVimPlugin {
      name = "vim-textobj-haskell";
      src = fetchgit {
        url = "https://github.com/gilligan/vim-textobj-haskell";
        rev = "13966e39249386bab0e79e76f859b6a539db664f";
        sha256 = "0mbfqqjr0xi5ld2jb6s7l5w4app314bbqvdxxa3sbf3x26pk377s";
      };
      dependencies = ["vim-textobj-user"];
    };

  "vim-textobj-user" = buildVimPlugin {
      name = "vim-textobj-user";
      src = fetchgit {
        url = "https://github.com/kana/vim-textobj-user";
        rev = "074ce2575543f790290b189860597a3dcac1f79d";
        sha256 = "15wnqkxjjksgn8a7d3lkbf8d97r4w159bajrcf1adpxw8hhli1vc";
      };
      dependencies = [];
    };
}
