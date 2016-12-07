#include <stdlib.h>
#include <stdio.h>
#include "client.h"

struct client_tab {
    int num;			/* current number of entries */
    int max;			/* allocated capacity */
    struct client *cls;		/* client array */
} cltab;

enum { 
    INIT = 1,			/* initial array size */
    GROW = 2 			/* array resize factor */
};

/* add: add client to cltab, returns new client total if successful */
int add(struct client *clp)
{
    struct client *mem;
    
    if (clp == NULL)
	return -1;

    if(cltab.cls == NULL) {	/* first time */
	cltab.cls = malloc(INIT * sizeof(struct client));
	if (cltab.cls == NULL)
	    return -1;
	cltab.num = 0;
	cltab.max = INIT;
    } else if (cltab.num >= cltab.max) { /* grow */
	mem = realloc(cltab.cls, (GROW * cltab.max) * sizeof(struct client));
	if (mem == NULL)
	    return -1;
	cltab.max *= GROW;
	cltab.cls = mem;
    }
    cltab.cls[cltab.num] = *clp;
    return ++cltab.num;
}

/* dump: dump all clients to stdout */
void dump(void)
{
    struct client *clp = cltab.cls;
    int i;

    printf("Dumping cltab:\n");
    for (i = 0; i < cltab.num; i++) {
	printf("\t%d: %s - %s\n", i, clp->name, clp->addr);
	clp++;
    }
}			
