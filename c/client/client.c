#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "client.h"

/* client: create new client on heap */
struct client *newcl(const char *name, const char *addr)
{
    struct client *clp;

    clp = malloc(sizeof(struct client));
    if (clp == NULL) 
	return NULL;

    /* copy name to clp */
    clp->name = malloc(strlen(name)+1);
    if (clp->name == NULL) {
	free(clp);
	return NULL;
    }
    strcpy(clp->name, name);	

    /* copy addr to clp */
    clp->addr = malloc(strlen(addr)+1);
    if (clp->addr == NULL) {
	free(clp->name);
	free(clp);
	return NULL;
    }
    strcpy(clp->addr, addr);
    return clp;
}
/* freecl: free client */
void freecl(struct client *clp)
{
    free(clp->name);
    free(clp->addr);
    free(clp);
}
/* printcl: print client to stdout */
void printcl(struct client *clp)
{
    printf("%s - %s\n", clp->name, clp->addr);
}
