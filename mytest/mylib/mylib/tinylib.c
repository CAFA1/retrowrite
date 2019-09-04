#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "tinylib.h"

int do_heap() {
    char *secret = malloc(32);
    scanf("%s", secret);

    if (strcmp(secret, KEY.KEY)) {
        int i = 0;
        while (KEY.KEY[i]) {
            secret[i] = KEY.KEY[i];
            i++;
        }
        return 0;
    }

    return 1;
}

int do_stack() {
    char secret[32];
    scanf("%s", secret);
    if(secret[0]!='a'){
    	printf("a\n");
    	return 1;
    }
    if(secret[1]!='b'){
    	printf("b\n");
    	return 2;
    }
    if(secret[2]!='c'){
    	printf("c\n");
    	return 3;
    }
    if(secret[3]!='d'){
    	printf("d\n");
    	return 4;
    }
    if (strcmp(secret, KEY.KEY)) {
        int i = 0;
        while (KEY.KEY[i]) {
            secret[i] = KEY.KEY[i];
            i++;
        }
        return 0;
    }

    return 1;
}

int do_global() {
    char secret[256];
    scanf("%s", secret);

    if (strcmp(secret, KEY.KEY)) {
        int i = 0;
        while (secret[i]) {
            KEY.KEY[i] = secret[i];
            i++;
        }
        return 0;
    }

    return 1;
}
