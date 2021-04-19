#!/usr/bin/env bash

project_root_dir="$1"
shift

mkdir -p $project_root_dir/dist-ide


proot -b $project_root_dir/dist-ide:$project_root_dir/dist-newstyle haskell-language-server $@
