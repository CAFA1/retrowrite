#!/bin/bash

mkdir -p /targets/libpng/gcc
mkdir -p /targets/libpng/afl-gcc
mkdir -p /targets/libpng/afl-clang-fast


git clone --depth 1 https://github.com/glennrp/libpng.git
cd libpng

autoreconf -f -i
CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/pngfix /targets/libpng/gcc/pngfix-gcc
mkdir -p /targets/libpng/afl-dyninst
afl-dyninst -i /targets/libpng/gcc/pngfix-gcc -o /targets/libpng/afl-dyninst/pngfix-dyninst -l pngfix-gcc

mkdir -p /targets/libpng/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/libpng/gcc/pngfix-gcc /targets/libpng/afl-retrowrite/pngfix-retrowrite.s
afl-gcc /targets/libpng/afl-retrowrite/pngfix-retrowrite.s -o /targets/libpng/afl-retrowrite/pngfix-retrowrite -lz -lm
deactivate

make clean

CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/pngfix /targets/libpng/afl-gcc/pngfix-afl-gcc
make clean

CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/pngfix /targets/libpng/afl-clang-fast/pngfix-afl-clang-fast
make clean
