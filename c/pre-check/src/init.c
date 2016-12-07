#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "esh.h"
#include "hlpr.h"

/* initialisation functions for esh */

/**
 * configure the prompt string
 *
 * @return newly allocated memory containing prompt string
 */
char *set_prompt()
{
    char *def = "esh % "; /* default prompt string */
    char *ptr; 

    /* TODO 
     * 
     * Add prompt configuration
     */

    /* for now lets just use the default */
    ptr = dupstr(def);

    return ptr;
}

/**
 * Initialisation routine
 *
 * @return < 0 on error
 */
int init()
{
    return 0;
}
