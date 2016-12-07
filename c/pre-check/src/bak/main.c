#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#inclued "../src/esh.h"

/* run the test suite */
int main(void)
{
    int tests = 0; 		/* total tests run */
    int fails = 0;		/* total tests failed */
    int res;

    fprintf(stderr, "Running test suite ...\n\n");
    
    res = t_parse();
    ++tests;
    if (res > 0)
	++fails;

    res = t_get_file(); 
    ++tests;
    if (res > 0)
	++fails;
	    
    res = t_cmnd_init(); 
    ++tests;
    if (res > 0)
	++fails;

    fprintf(stderr, "\nTotal tests run: %d\n", tests);
    if (fails > 0)

	fprintf(stderr, "Total tests failed: %d\n", fails);

    return(0);
}
