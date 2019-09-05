CC?=gcc
CDIR=$(shell pwd)
BUILD=$(CDIR)/../gcc/

all:  so static1 static2 



so:
	gcc -shared -fpic -fvisibility=hidden -o ../gcc/libtiny.so tinylib.c 
	strip ../gcc/libtiny.so


	

static1:
	gcc -c tinylib.c -o tinylib.o
	ar -r ../gcc/libtiny.a tinylib.o
	gcc ../retrowrite/driver.c -ltiny -L ../gcc/ -static -o ../retrowrite/static_driver

static2:
	gcc -c ../retrowrite/libtiny.s -o tinylib.o
	ar -r ../retrowrite/libtiny.a tinylib.o
	gcc ../retrowrite/driver.c -ltiny -L ../retrowrite/ -static -o ../retrowrite/static_driver1
clean:
	rm $(BUILD)*
