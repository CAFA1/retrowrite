.PHONY : mytest 
mytest:
	#-fpic
	gcc -fpic -o mytest/mytest/mytest/mytest mytest/mytest/mytest/mytest.c 
	#strip mytest/mytest/mytest/mytest
	python -m librw.rw mytest/mytest/mytest/mytest mytest/mytest/mytest/mytest-retrowrite.s
	export AFL_KEEP_ASSEMBLY=1
	docker/afl/afl-gcc  mytest/mytest/mytest/mytest-retrowrite.s -o mytest/mytest/mytest/mytest-retrowrite
	docker/afl/afl-fuzz -i mytest/mytest/fuzz/in -o mytest/mytest/fuzz/out/ mytest/mytest/mytest/mytest-retrowrite