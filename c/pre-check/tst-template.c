#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

/* prototypes from esh.h */

/* prototypes from .c */

/* prototypes for tests */
int t_();

/* run the test suite */
int main(void)
{
    int fails = 0;

    fprintf(stderr, "Running test suite ...\n");
    
    fails += t_(); 

    fprintf(stderr, "\n Total tests failed: %d\n", fails);

    return(0);
}

/* test template */
int t_()
{
    int res = 1;

    fprintf(stderr, "t_ not yet implemented\n");

    return res;
}
