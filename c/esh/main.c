/* #define _GNU_SOURCE */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "esh.h"

/* main shell loop */
int loop()
{
    struct stmnt *stmnt = NULL;
    
    if (init() < 0) {
	perror("main: loop, initialisation error");
	exit(1);
    }

/*    if (;;) { */ /* compiler complains about this ? */
    while(1) { 
	stmnt = stmnt_read();
	if (stmnt == NULL) 
	    return -1;
	
	/* just print the statemnet */
	stmnt_print(stmnt);
	stmnt_free(stmnt);
    }

    return 0;
}

int main (int argc, char *argv[])
{
    /* initialisation routines */
    if (init() != 0) {
	perror("main: initialisation failed");
	exit(1);
    }

    /* main loop */
    loop();

    PRINT("%s\n", "Error: reached end of main");
    exit(1); /* should never get here */
}
