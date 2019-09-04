CC?=gcc
CDIR=$(shell pwd)
BUILD=$(CDIR)/../gcc/

all:  $(BUILD)overflow_stack static1 static2

$(BUILD)tinylib.o: tinylib.c
	$(CC) -c $< -o $@ -fpic

$(BUILD)libtiny.so: $(BUILD)tinylib.o
	$(CC) -shared -o $@ $< 

$(BUILD)overflow_stack: $(BUILD)libtiny.so
	$(CC) -fPIE -pie -L$(BUILD) -Wall -o $@ tiny.c -DSTACK_OVERFLOW=1 -ltiny 

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
