#!/bin/bash

mkdir -p /targets/libarchive/gcc
mkdir -p /targets/libarchive/afl-gcc
mkdir -p /targets/libarchive/afl-clang-fast


git clone --depth 1 https://github.com/libarchive/libarchive.git
cd libarchive

./build/autogen.sh
CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/bsdtar /targets/libarchive/gcc/bsdtar-gcc
mkdir -p /targets/libarchive/afl-dyninst
afl-dyninst -i /targets/libarchive/gcc/bsdtar-gcc -o /targets/libarchive/afl-dyninst/bsdtar-dyninst -l bsdtar-gcc

mkdir -p /targets/libarchive/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/libarchive/gcc/bsdtar-gcc /targets/libarchive/afl-retrowrite/bsdtar-retrowrite.s
afl-gcc /targets/libarchive/afl-retrowrite/bsdtar-retrowrite.s -o /targets/libarchive/afl-retrowrite/bsdtar-retrowrite -llzma -lcrypto -lz -lxml2 -lbz2 -lacl -llz4
deactivate

make clean

CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/bsdtar /targets/libarchive/afl-gcc/bsdtar-afl-gcc
make clean

CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/bsdtar /targets/libarchive/afl-clang-fast/bsdtar-afl-clang-fast
make clean
