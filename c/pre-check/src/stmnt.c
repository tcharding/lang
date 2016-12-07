#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "esh.h"

/* functions for maniputating statements (refer: EBNF.txt)
 * 
 *
 * Progress Thus Far: statement = cmnd
 */

/**
 * Initialise command. Allocates memeroy for struct and sets members to NULL.
 *
 * @param filename is copied into struct
 */
struct cmnd *cmnd_init()
{
    struct cmnd *new;

    new = malloc(sizeof(struct cmnd *));
    if (new == NULL) {
	perror("cmnd_init: malloc error");
	exit(-ENOMEM);
    }

    new->path = NULL;
    new->argv = NULL;

    return new;
}

/**
 * free cmnd structure
 */
void cmnd_free(struct cmnd *cmnd)
{
    if (cmnd == NULL)
	return;
    if (cmnd->path != NULL)
	free(cmnd->path);
    if (cmnd->argv != NULL) {
	char **argv = cmnd->argv;
	char *tmp;
	while(*argv != NULL) {
	    tmp = *argv;		
	    ++argv;
	    free(tmp);
	}
    }	
}
