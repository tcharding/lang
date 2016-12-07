#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

/* prototypes from esh.h */
struct cmnd *cmnd_init();
void cmnd_free(struct cmnd *cptr);

/* prototypes from stmnt.c */

/* prototypes for tests */
int t_cmnd();


/* run the test suite */
int main(void)
{
    int fails = 0;

    fprintf(stderr, "Running test suite ...\n");
    
    fails += t_cmnd(); 

    fprintf(stderr, "\n Total tests failed: %d\n", fails);

    return(0);
}

int t_cmnd()
{
    int res = 0;
    struct cmnd*tst;
    
    tst = cmnd_init();
    cmnd_free(tst);

    return res;
}
