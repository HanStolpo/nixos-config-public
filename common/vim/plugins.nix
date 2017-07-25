{pkgs, fetchgit} :

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {

  #"vim-polyglot" = buildVimPlugin {
    #name = "vim-polyglot";
    #src = fetchgit {
          #url = "https://github.com/sheerun/vim-polyglot";
          #rev = "1422f7a75ce0b382d601238c5979b04473b9021e";
          #sha256 = "0jqb75lrf75br9wg95cxcy3aal1bk929881gy4ly1n0r6fv96yz1";
        #};
    #dependencies = [];
  #};

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
      sha256 = "0r6k3fh0qpg95a02hkks3z4lsjailkd5ddlnn83w7f51jj793v3b";
    };
  };

  # "elm-vim" = buildVimPlugin {
  #   name = "elm-vim";
  #   src = fetchgit {
  #     url = "https://github.com/ElmCast/elm-vim";
  #     rev = "6527c8a9e1d1af31c81e60b6b40bf3316c7fbdf2";
  #     sha256 = "0aj1cd5dy7z48lf6vzg76r787hgs4z5f11bczvvs1h99qik1rgbc";
  #   };
  # };

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
        rev = "3ca4c7de96dfc1a76b529ac8fa336bd5fe1d7f6c";
        sha256 = "0jjfnq5sg28c5ifpsrgzhwd38jg3sl8qak5ia1x4n8rkdrvmd1vj";
      };
      dependencies = [];
    };

  "vim-clang-format" = buildVimPlugin {
      name = "vim-clang-format";
      src = fetchgit {
        url = "https://github.com/rhysd/vim-clang-format";
        rev = "95051583232fb9ad27d55e417b6ffc3933c50738";
        sha256 = "";
      };
      dependencies = [];
    };

}
