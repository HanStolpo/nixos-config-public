{ stdenv, writeText }:

let
    haskell-vim-now     = builtins.readFile ./vimrc/haskell-vim-now.vim;
    my_vim_rc  = builtins.readFile ./vimrc/my_vim_rc.vim;
in

''
    ${haskell-vim-now}

    ${my_vim_rc}

''
