#!/bin/bash

mkdir -p /targets/bzip2/gcc
mkdir -p /targets/bzip2/afl-gcc
mkdir -p /targets/bzip2/afl-clang-fast


wget https://fossies.org/linux/misc/bzip2-1.0.6.tar.gz && tar -xvf bzip2-1.0.6.tar.gz && mv bzip2-1.0.6 bzip2
cd bzip2

FOO=foo make install PREFIX=/tmp/install CC=gcc
cp /tmp/install/bin/bzip2 /targets/bzip2/gcc/bzip2-gcc
mkdir -p /targets/bzip2/afl-dyninst
afl-dyninst -i /targets/bzip2/gcc/bzip2-gcc -o /targets/bzip2/afl-dyninst/bzip2-dyninst -l bzip2-gcc

mkdir -p /targets/bzip2/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/bzip2/gcc/bzip2-gcc /targets/bzip2/afl-retrowrite/bzip2-retrowrite.s
afl-gcc /targets/bzip2/afl-retrowrite/bzip2-retrowrite.s -o /targets/bzip2/afl-retrowrite/bzip2-retrowrite 
deactivate

make clean

FOO=foo make install PREFIX=/tmp/install CC=afl-gcc
cp /tmp/install/bin/bzip2 /targets/bzip2/afl-gcc/bzip2-afl-gcc
make clean

FOO=foo make install PREFIX=/tmp/install CC=afl-clang-fast
cp /tmp/install/bin/bzip2 /targets/bzip2/afl-clang-fast/bzip2-afl-clang-fast
make clean
