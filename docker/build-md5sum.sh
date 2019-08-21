#!/bin/bash

mkdir -p /targets/md5sum/gcc
mkdir -p /targets/md5sum/afl-gcc
mkdir -p /targets/md5sum/afl-clang-fast


cp -r /src/md5sum/coreutils-8.24-lava-safe md5sum
cd md5sum

FORCE_UNSAFE_CONFIGURE=1 CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/md5sum /targets/md5sum/gcc/md5sum-gcc
mkdir -p /targets/md5sum/afl-dyninst
afl-dyninst -i /targets/md5sum/gcc/md5sum-gcc -o /targets/md5sum/afl-dyninst/md5sum-dyninst -l md5sum-gcc

mkdir -p /targets/md5sum/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/md5sum/gcc/md5sum-gcc /targets/md5sum/afl-retrowrite/md5sum-retrowrite.s
afl-gcc /targets/md5sum/afl-retrowrite/md5sum-retrowrite.s -o /targets/md5sum/afl-retrowrite/md5sum-retrowrite 
deactivate

make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/md5sum /targets/md5sum/afl-gcc/md5sum-afl-gcc
make clean
FORCE_UNSAFE_CONFIGURE=1 CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/bin/md5sum /targets/md5sum/afl-clang-fast/md5sum-afl-clang-fast
make clean