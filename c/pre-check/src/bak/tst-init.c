#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "esh.h"

/* prototypes from .c */

/* prototypes for tests */
int t_set_prompt();
int t_init();

/* run the test suite */
int main(void)
{
    int fails = 0;

    fprintf(stderr, "Running test suite ...\n\n");

    fails += t_set_prompt(); 
    fails += t_init(); 

    fprintf(stderr, "\n Total tests failed: %d\n", fails);

    return(0);
}

int t_set_prompt()
{
    int res = 1;

    fprintf("t_set_prompt not yet implemented\n");

    return res;
}

int t_set_init()
{
    int res = 1;

    fprintf("t_init not yet implemented\n");

    return res;
}
