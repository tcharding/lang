#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

/*
 * Helper functions
 */ 

/**
 * Duplicate a string.
 *
 * @returns newly allocated memory containing str. Must be free'd.
 */
char *dupstr(const char *str)
{
    char *new;

    if ((new = malloc(strlen(str) + 1)) == NULL) { /* +1 for '\0' */
	perror("dupstr: malloc error");
	return NULL;
    } 
    strcpy(new, str);
    
    return new;
}
