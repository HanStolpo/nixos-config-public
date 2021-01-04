#!/usr/bin/env bash

project_root_dir="$1"
shift

mkdir -p $project_root_dir/dist-ide

cat <<EOF > $project_root_dir/cabal.project.local.ide
tests: True
jobs: 7
keep-going: True
allow-newer: all
allow-older: all
optimization: False
debug-info: False
profiling: False

package *
  ghc-options:
    -fwrite-ide-info -hiedir $project_root_dir/dist-ide/hie
EOF

proot -b $project_root_dir/dist-ide:$project_root_dir/dist-newstyle -b $project_root_dir/cabal.project.local.ide:$project_root_dir/cabal.project.local haskell-language-server $@
