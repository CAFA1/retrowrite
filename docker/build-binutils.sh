#!/bin/bash

mkdir -p /targets/binutils/gcc
mkdir -p /targets/binutils/afl-gcc
mkdir -p /targets/binutils/afl-clang-fast


git clone git://sourceware.org/git/binutils-gdb.git && mv binutils-gdb binutils
cd binutils

CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/readelf /targets/binutils/gcc/readelf-gcc
mkdir -p /targets/binutils/afl-dyninst
afl-dyninst -i /targets/binutils/gcc/readelf-gcc -o /targets/binutils/afl-dyninst/readelf-dyninst -l readelf-gcc

mkdir -p /targets/binutils/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/binutils/gcc/readelf-gcc /targets/binutils/afl-retrowrite/readelf-retrowrite.s
afl-gcc /targets/binutils/afl-retrowrite/readelf-retrowrite.s -o /targets/binutils/afl-retrowrite/readelf-retrowrite 
deactivate

make distclean
CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/readelf /targets/binutils/afl-gcc/readelf-afl-gcc
make distclean
CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/readelf /targets/binutils/afl-clang-fast/readelf-afl-clang-fast
make distclean