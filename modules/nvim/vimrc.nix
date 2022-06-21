{ stdenv, writeText, haskellPackages, nodejs, python3, fd, ripgrep, languagetool }:

let
  haskell-vim-now = builtins.readFile ./vimrc/haskell-vim-now.vim;
  my_vim_rc = builtins.readFile ./vimrc/my_vim_rc.vim;
in

''
  call setenv("PATH", "${nodejs}/bin:${python3}/bin:${fd}/bin:/${languagetool}/bin:${ripgrep}/bin:" . getenv("PATH") )

  ${haskell-vim-now}

  ${my_vim_rc}

  let g:languagetool_cmd='${languagetool}/bin/languagetool-commandline'
''
