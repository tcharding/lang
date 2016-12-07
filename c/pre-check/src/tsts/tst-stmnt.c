#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "hlpr.h"

/* prototypes from esh.h */
struct cmnd *cmnd_init();
void cmnd_free(struct cmnd *cptr);

/* prototypes from stmnt.c */

int t_cmnd(int *cnt)
{
/*    char *fnc = "t_cmnd"; */
    int res = 0;
    struct cmnd *tst;
    
    ++*cnt;
    tst = cmnd_init();
    cmnd_free(tst);

    return res;
}
