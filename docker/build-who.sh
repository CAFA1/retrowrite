#!/bin/bash

mkdir -p /targets/who/gcc
mkdir -p /targets/who/afl-gcc
mkdir -p /targets/who/afl-clang-fast


cp -r /src/who/coreutils-8.24-lava-safe who
cd who

FORCE_UNSAFE_CONFIGURE=1 CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/who /targets/who/gcc/who-gcc
mkdir -p /targets/who/afl-dyninst
afl-dyninst -i /targets/who/gcc/who-gcc -o /targets/who/afl-dyninst/who-dyninst -l who-gcc

mkdir -p /targets/who/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/who/gcc/who-gcc /targets/who/afl-retrowrite/who-retrowrite.s
afl-gcc /targets/who/afl-retrowrite/who-retrowrite.s -o /targets/who/afl-retrowrite/who-retrowrite 
deactivate

make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/who /targets/who/afl-gcc/who-afl-gcc
make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/who /targets/who/afl-clang-fast/who-afl-clang-fast
make clean