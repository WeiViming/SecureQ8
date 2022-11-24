#!/bin/bash

name="MP-SPDZ"
mpspdz_repo="https://github.com/data61/MP-SPDZ"

if ! [ -e $name/Makefile ]; then
    git clone $mpspdz_repo -b v0.1.8 
fi

cd $name
if [ -e ".gitmodules" ]; then
    rm .gitmodules
    mv ../.gitsub-MP-SPDZ .gitmodules
fi

echo CXX = clang++ >> CONFIG.mine
echo USE_NTL = 1 >> CONFIG.mine
make -j8 tldr
mkdir static
make -j8 {static/,}{{replicated,ps-rep}-{ring,field},semi2k,hemi,cowgear,spdz2k}-party.x
