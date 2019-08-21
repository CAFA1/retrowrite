#!/bin/bash

mkdir -p /targets/tcpdump/gcc
mkdir -p /targets/tcpdump/afl-gcc
mkdir -p /targets/tcpdump/afl-clang-fast


git clone --depth 1 https://github.com/the-tcpdump-group/tcpdump.git
cd tcpdump

CC=gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/sbin/tcpdump /targets/tcpdump/gcc/tcpdump-gcc
mkdir -p /targets/tcpdump/afl-dyninst
afl-dyninst -i /targets/tcpdump/gcc/tcpdump-gcc -o /targets/tcpdump/afl-dyninst/tcpdump-dyninst -l tcpdump-gcc

mkdir -p /targets/tcpdump/afl-retrowrite
source /retrowrite/retro/bin/activate
python -m librw.rw /targets/tcpdump/gcc/tcpdump-gcc /targets/tcpdump/afl-retrowrite/tcpdump-retrowrite.s
afl-gcc /targets/tcpdump/afl-retrowrite/tcpdump-retrowrite.s -o /targets/tcpdump/afl-retrowrite/tcpdump-retrowrite -lpcap -lcrypto
deactivate

make clean

CC=afl-gcc ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/sbin/tcpdump /targets/tcpdump/afl-gcc/tcpdump-afl-gcc
make clean

CC=afl-clang-fast ./configure --prefix=/tmp/install --enable-shared=no --enable-static=yes
make
make install
cp /tmp/install/sbin/tcpdump /targets/tcpdump/afl-clang-fast/tcpdump-afl-clang-fast
make clean
