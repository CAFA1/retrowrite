all:
	python bin2s.py ../mytest/mytest/mytest/mytest mytest.s
	gcc -g -o mytest_gcc mytest.s
	../docker/afl/afl-gcc -o mytest_afl mytest.s
test:
	../docker/afl/afl-fuzz -i fuzz/in -o fuzz/out ./mytest_afl