#!/bin/bash

mkdir -p /targets/libtiff/gcc
mkdir -p /targets/libtiff/afl-gcc
mkdir -p /targets/libtiff/afl-clang-fast


git clone --depth 1 https://gitlab.com/libtiff/libtiff
cd libtiff

./autogen.sh
CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/tiff2rgba /targets/libtiff/gcc/tiff2rgba-gcc
mkdir -p /targets/libtiff/afl-dyninst
afl-dyninst -i /targets/libtiff/gcc/tiff2rgba-gcc -o /targets/libtiff/afl-dyninst/tiff2rgba-dyninst -l tiff2rgba-gcc

mkdir -p /targets/libtiff/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/libtiff/gcc/tiff2rgba-gcc /targets/libtiff/afl-retrowrite/tiff2rgba-retrowrite.s
afl-gcc /targets/libtiff/afl-retrowrite/tiff2rgba-retrowrite.s -o /targets/libtiff/afl-retrowrite/tiff2rgba-retrowrite -lz -lm -llzma
deactivate

make clean

CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/tiff2rgba /targets/libtiff/afl-gcc/tiff2rgba-afl-gcc
make clean

CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/tiff2rgba /targets/libtiff/afl-clang-fast/tiff2rgba-afl-clang-fast
make clean
