#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "esh.h"

/* initialisation functions for esh */

/**
 * configure the prompt string
 *
 * @return newly allocated memory containing prompt string
 */
char *prompt()
{
    char *def = "esh % "; /* default prompt string */
    char *ptr = NULL; 

    /* TODO 
     * 
     * Add prompt configuration
     */

    /* for now lets just use the default */
    ptr = strdup(def); /* NULL on error */
/*    PRINT("ptr: %s\n", ptr); */
    return ptr;
}

/**
 * Initialisation routine
 *
 * @return < 0 on error
 */
int init()
{
    char *global_prompt;

    global_prompt = prompt();
    if (global_prompt == (char *)0) {
	return -1;
    }

    return 0;
}
