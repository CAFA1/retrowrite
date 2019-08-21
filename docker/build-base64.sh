#!/bin/bash

mkdir -p /targets/base64/gcc
mkdir -p /targets/base64/afl-gcc
mkdir -p /targets/base64/afl-clang-fast


cp -r /src/base64/coreutils-8.24-lava-safe base64
cd base64

FORCE_UNSAFE_CONFIGURE=1 CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/base64 /targets/base64/gcc/base64-gcc
mkdir -p /targets/base64/afl-dyninst
afl-dyninst -i /targets/base64/gcc/base64-gcc -o /targets/base64/afl-dyninst/base64-dyninst -l base64-gcc

mkdir -p /targets/base64/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/base64/gcc/base64-gcc /targets/base64/afl-retrowrite/base64-retrowrite.s
afl-gcc /targets/base64/afl-retrowrite/base64-retrowrite.s -o /targets/base64/afl-retrowrite/base64-retrowrite 
deactivate

make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/base64 /targets/base64/afl-gcc/base64-afl-gcc
make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/base64 /targets/base64/afl-clang-fast/base64-afl-clang-fast
make clean