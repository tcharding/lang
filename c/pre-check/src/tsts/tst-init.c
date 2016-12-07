#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "hlpr.h"

/* prototypes from init.c */
char *set_prompt();

int t_set_prompt(int *cnt)
{
    char *fnc = "t_set_prompt";
    int res = 0;
    char *p;
    char *tc;

    ++*cnt;
    tc = "esth % ";
    p = set_prompt();
    if(strcmp(p, tc) != 0) {
	TFP(__FILE__, __LINE__, fnc, tc);
	++res;
    }

    free(p);
    return res;
}

int t_set_init(int *cnt)
{
    int res = 1;

    fprintf(stderr, "t_init not yet implemented\n");

    return res;
}
