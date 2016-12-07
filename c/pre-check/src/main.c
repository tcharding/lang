/* #define _GNU_SOURCE */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "esh.h"

int loop(); /* main read loop */

int main (int argc, char *argv[])
{
    char *prompt;
    
    /* initialisation routines */
    if (init() != 0) {
	perror("main: initialisation failed");
	exit(1);
    }

    /* set the prompt */
    prompt = set_prompt(); 	/* exits on error */

    /* main loop */
    if (loop() < 0) {
	perror("main: main loop failed");
	exit(1);
    }

    free(prompt);

    exit(0);
}

/* main read loop */
int loop()
{
    return 0;
}

