#include <stdlib.h>
#include <stdio.h>
#include "client.h"

enum { NUM = 3 };		/* number of clients to process */

static int tst_newcl_add(void);

/* main: test store */
int main(void)
{ 
    int failed = 0;
/*
    printf("Testing client ... ");
    if (tst_newcl_add())
      ++failed; 
    if (failed)
	printf("\tFailed: %d\n", failed);
    else
	puts("ok");
*/
    if (tst_newcl_add())
      ++failed; 
    return failed;
}

int tst_newcl_add(void)
{
    struct client *clp;
    int res, i;
    char buf[256];

    for (i = 1; i <= NUM; i++) {
	sprintf(buf, "john smith (%d)", i);
	clp = newcl(buf, "address@first.com");
	if (clp == NULL)
	    fprintf(stderr, "Failed while creating entry: %i\n", i);
	res = add(clp);
	if (res != i) 
	    fprintf(stderr, "Failed while adding entry: %i (res=%d)\n", i, res);
    }
    /* free what we created */
    foreach(&freecl);

    return 0;
}
