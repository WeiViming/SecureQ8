#!/bin/bash

name="MP-SPDZ"

if ! [ -d $name ]; then
    git submodule update --init
fi

cd $name
if [ -e ".gitmodules" ]; then
    rm .gitmodules
    mv ../.gitsub-MP-SPDZ .gitmodules
fi
git submodule update --init

echo CXX = clang++ >> CONFIG.mine
echo USE_NTL = 1 >> CONFIG.mine
make -j8 tldr
mkdir static
make -j8 {static/,}{{replicated,ps-rep}-{ring,field},semi2k,hemi,cowgear,spdz2k}-party.x
