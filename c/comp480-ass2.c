#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

/*
 * Program Description
 *
 * Declare variables
 *
 * Check user supplied file name
 *
 * Fork, printing error and exiting on failure
 * 
 * Child process image is replaced with new process image 
 *  with call to execv
 *
 * Parent process waits for child to complete, checking return
 *  prints error message and exits if call wc fails.
 * 
 * Exit program successfully
 */

/*
 * Fork child process, parent to wait on child. 
 * Child to exec 'wc'
 */
int main(int argc, char *argv[])
{
    char *path= "/usr/bin/wc"; 	/* exec[vl]() */
    pid_t pid;			/* fork() */
    int status;			/* wait() */

    /* check program called with correct arguments */
    if (argc < 2) {
	fprintf(stderr, "Usage: %s [options] <filename>\n", *argv);
	exit(EXIT_FAILURE);
    }

    /* fork */
    if ((pid = fork()) < 0) {
	perror("Error: fork failed");
	exit(EXIT_FAILURE);
    } else if (pid == 0) { /* child process */
	/* execl("/usr/bin/wc", "wc", argv[1], (char *)0); */
	execv(path, argv); /* enable user to pass in options */
    } else { /* parent process */
	wait(&status);
	if (status != 0) {
	    fprintf(stderr, "call to wc failed");
	    exit(EXIT_FAILURE);
	}
    }
    exit(EXIT_SUCCESS);
}
