#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "hlpr.h"

/* prototypes from hlpr.c */
char *dupstr(const char *str);

/* prototypes for tests */
int t_dupstr(int *cnt);

/* test template */
int t_dupstr(int *cnt)
{
    char *fnc = "t_dupstr";
    int res = 0;
    char *tc;
    char *new;

    ++*cnt;			/* increment count */
    tc = "This one";
    new = dupstr(tc);
    if (strcmp(tc, new) != 0) {
	TFP(__FILE__, __LINE__, fnc, tc);
	++res;
    }
    free(new);

    ++*cnt;		
    tc = "And this \n one";
    new = dupstr(tc);
    if (strcmp(tc, new) != 0) {
	TFP(__FILE__, __LINE__, fnc, tc);
	++res;
    }
    free(new);

    return res;
}
