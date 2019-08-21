#!/bin/bash

mkdir -p /targets/file/gcc
mkdir -p /targets/file/afl-gcc
mkdir -p /targets/file/afl-clang-fast


git clone --depth 1 https://github.com/file/file.git
cd file

autoreconf -i
CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/file /targets/file/gcc/file-gcc
mkdir -p /targets/file/afl-dyninst
afl-dyninst -i /targets/file/gcc/file-gcc -o /targets/file/afl-dyninst/file-dyninst -l file-gcc

mkdir -p /targets/file/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/file/gcc/file-gcc /targets/file/afl-retrowrite/file-retrowrite.s
afl-gcc /targets/file/afl-retrowrite/file-retrowrite.s -o /targets/file/afl-retrowrite/file-retrowrite -lz
deactivate

make clean

CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/file /targets/file/afl-gcc/file-afl-gcc
make clean

CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/file /targets/file/afl-clang-fast/file-afl-clang-fast
make clean
