mytest_pic:
	gcc -fpic -o mytest/mytest_pic mytest/mytest.c
	python bin2s.py mytest/mytest_pic mytest/mytest_pic.s
	gcc -g -o mytest/mytest_pic_gcc mytest/mytest_pic.s
	../docker/afl/afl-gcc -o mytest/mytest_pic_afl mytest/mytest_pic.s
test_pic:
	../docker/afl/afl-fuzz -i fuzz/in -o fuzz/out mytest/mytest_pic_afl

mytest_pic_strip:
	gcc -fpic -o mytest/mytest_pic_strip mytest/mytest.c
	strip mytest/mytest_pic_strip
	python bin2s.py mytest/mytest_pic_strip mytest/mytest_pic_strip.s
	gcc -g -o mytest/mytest_pic_strip_gcc mytest/mytest_pic_strip.s
	../docker/afl/afl-gcc -o mytest/mytest_pic_strip_afl mytest/mytest_pic_strip.s
test_pic_strip:
	../docker/afl/afl-fuzz -i fuzz/in -o fuzz/out mytest/mytest_pic_strip_afl

mytest_nopic:
	gcc -o mytest/mytest_nopic mytest/mytest.c
	python bin2s.py mytest/mytest_nopic mytest/mytest_nopic.s
	gcc -g -o mytest/mytest_nopic_gcc mytest/mytest_nopic.s
	../docker/afl/afl-gcc -o mytest/mytest_nopic_afl mytest/mytest_nopic.s
test_nopic:
	../docker/afl/afl-fuzz -i fuzz/in -o fuzz/out mytest/mytest_nopic_afl


mytest_nopic_strip:
	gcc  -o mytest/mytest_nopic_strip mytest/mytest.c
	strip mytest/mytest_nopic_strip
	python bin2s.py mytest/mytest_nopic_strip mytest/mytest_nopic_strip.s
	gcc -g -o mytest/mytest_nopic_strip_gcc mytest/mytest_nopic_strip.s
	../docker/afl/afl-gcc -o mytest/mytest_nopic_strip_afl mytest/mytest_nopic_strip.s
test_nopic_strip:
	../docker/afl/afl-fuzz -i fuzz/in -o fuzz/out mytest/mytest_nopic_strip_afl

readelf_nostrip:
	python bin2s.py readelf/readelf readelf/readelf.s
	gcc -g -o readelf/readelf_gcc readelf/readelf.s