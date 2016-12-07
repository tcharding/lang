#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

#define SIZE 128

/*
 * example of getline use
 */
int main(int argc, char *argv[])
{

    char *lptr = NULL;
    size_t n = 0;
    int read;

    for (;;) {
	printf("Enter line to be read with getline()\n");
	read = getline(&lptr, &n, stdin);
	if (read == -1) {
	    perror("getline error");
	    return 1;
	}
	printf("we got: %s", lptr);
    }

    exit(0);
}
