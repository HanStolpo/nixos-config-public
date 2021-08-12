{ stdenv, writeText, haskellPackages, nodejs, python3, languagetool }:

let
  haskell-vim-now = builtins.readFile ./vimrc/haskell-vim-now.vim;
  my_vim_rc = builtins.readFile ./vimrc/my_vim_rc.vim;
in

''
  call setenv("PATH", getenv("PATH") . ":${nodejs}/bin:${python3}/bin")
  let g:deoplete#enable_at_startup = 1

  ${haskell-vim-now}

  ${my_vim_rc}

  let g:languagetool_cmd='${languagetool}/bin/languagetool-commandline'
''

#  " auto formatting via vim-autoformat
#  let g:formatdef_ch_hs_format = '"${haskellPackages.ch-hs-format}/bin/ch-hs-format"'
#  let g:formatters_haskell = ['ch_hs_format']
#
#  " au BufEnter *.hs set formatprg="${haskellPackages.ch-hs-format}/bin/ch-hs-format"
