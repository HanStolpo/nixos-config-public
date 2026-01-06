{ stdenv, writeText, haskellPackages, nodejs, python3, fd, ripgrep, languagetool, tree-sitter, clang }:

let
  config_lua = builtins.readFile ./config.lua;
in

''
  " Set PATH for external tools
  call setenv("PATH", "${nodejs}/bin:${python3}/bin:${fd}/bin:${languagetool}/bin:${ripgrep}/bin:${tree-sitter}/bin:${clang}/bin:" . getenv("PATH") )

  " Plugin configuration: grammarous
  let g:grammarous#languagetool_cmd = '${languagetool}/bin/languagetool-commandline'

  " Load main Lua configuration
  lua << EOF
${config_lua}
EOF
''
