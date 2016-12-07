#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include "esh.h"

enum { NONE , SINGLE, DOUBLE }; /* quote character values */

char *get_file(const char *input);
char *get_path(const char *file);

/**
 * parse input into cmnd.
 *
 * @return pointer to newly allocated memory, free with free_cmnd
 */
struct cmnd *parse(const char *input) 
{
    struct cmnd *cmnd;
    char *file;

    /* initialise new statement */
    if ((cmnd = cmnd_init()) == NULL) {
	perror("parse: cmnd init fail");
	exit(-ENOMEM);
    }

    /* get file name from input and create pathname */
    if ((file = get_file(input)) == NULL) {
	perror("parse: get_file fail");
	return NULL;
    }
    if ((cmnd->path = get_path(file)) == NULL) {
	esh_err("command not found: %s", file);
	return cmnd; 		/* remember to free this */
    }
    
    
    /* TODO 
     * 
     * so far only single file command is processed
     */
    cmnd->argv = &cmnd->path;	/* set argv[0] */
    
    return cmnd;		

}
/**
 * get_file. Gets the file name out of input
 *
 * @param input string to parse
 * @return pointer to newly allocated memory containing NULL on error
 */
char *get_file(const char *input)
{
    char *fnptr; 		/* ptr to filename */
    size_t len;			/* length of filename */
    char *sptr;			/* pointer into input */
    int space = ' ';
    
    if (input == NULL)
	return NULL;

    if ((sptr = strchr(input, space)) == NULL) { /* no spaces in input */
	len = strlen(input);
    	fnptr = malloc(len + 1); /* +1 for '\0' */
	if (fnptr == NULL) {
    	    perror("get_file: malloc error");
    	    return NULL;
    	}
	strcpy(fnptr, input);
    } else {
	len = sptr - input;		   /* calculate using ptr arithmetic */
    	fnptr = malloc( len + 1); /* +1 for '\0' */
    	if (fnptr == NULL) {
    	    perror("get_file: malloc error");
    	    return NULL;
    	}
	strncpy(fnptr, input, len);
    }
    return fnptr;
}

/**
 * TODO
 */
char *get_path(const char *file)
{
    return NULL;
}
