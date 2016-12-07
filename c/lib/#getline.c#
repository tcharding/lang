#include <stdio.h>

/*
 * Useful functions
 * 
 */ 
int getline(char line[], int limit)
{
    int i;
    char c;

    for(i = 0; i < limit; i++) {
	c = getchar();
	if (c == EOF) {
	    line[i] = '\0';
	    return i;
	}
	line[i] = c; /* store character */
	if (c == '\n') {
	    line[i] = '\0';
	    return i;
	}
    }
    return i;
}
