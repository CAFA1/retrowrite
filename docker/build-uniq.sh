#!/bin/bash

mkdir -p /targets/uniq/gcc
mkdir -p /targets/uniq/afl-gcc
mkdir -p /targets/uniq/afl-clang-fast


cp -r /src/uniq/coreutils-8.24-lava-safe uniq
cd uniq

FORCE_UNSAFE_CONFIGURE=1 CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/uniq /targets/uniq/gcc/uniq-gcc
mkdir -p /targets/uniq/afl-dyninst
afl-dyninst -i /targets/uniq/gcc/uniq-gcc -o /targets/uniq/afl-dyninst/uniq-dyninst -l uniq-gcc

mkdir -p /targets/uniq/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/uniq/gcc/uniq-gcc /targets/uniq/afl-retrowrite/uniq-retrowrite.s
afl-gcc /targets/uniq/afl-retrowrite/uniq-retrowrite.s -o /targets/uniq/afl-retrowrite/uniq-retrowrite 
deactivate

make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/uniq /targets/uniq/afl-gcc/uniq-afl-gcc
make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/uniq /targets/uniq/afl-clang-fast/uniq-afl-clang-fast
make clean