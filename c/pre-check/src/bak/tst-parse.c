#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

/* prototypes from esh.h */
struct cmnd *parse(const char *input);

/* prototypes from parse.c */
char *get_file(const char *input);
struct cmnd *cmnd_init(const char *filename);

/* prototypes for tests */
int t_parse();
int t_get_file();
int t_cmnd_init();

/* run the test suite */
int main(void)
{
    int tests = 0; 		/* total tests run */
    int fails = 0;		/* total tests failed */
    int res;

    fprintf(stderr, "Running test suite ...\n\n");
    
    res = t_parse();
    ++tests;
    if (res > 0)
	++fails;

    res = t_get_file(); 
    ++tests;
    if (res > 0)
	++fails;
	    
    res = t_cmnd_init(); 
    ++tests;
    if (res > 0)
	++fails;

    fprintf(stderr, "\nTotal tests run: %d\n", tests);
    if (fails > 0)

	fprintf(stderr, "Total tests failed: %d\n", fails);

    return(0);
}

int t_parse()
{
    int res = 1;

    fprintf(stderr, " t_parse failed: not yet implemented\n");

    return res;
}
int t_cmnd_init()
{
    int res = 1;

    fprintf(stderr, " t_cmnd_init failed: not yet implemented\n");

    return res;
}
int t_get_file()
{
    int res = 0;
    char *fnptr;
    char *cmnd = "cmnd";
    int cmp = 0;

    fnptr = get_file("cmnd");
    cmp = strcmp(fnptr, cmnd);
    if (cmp != 0) {
	fprintf(stderr, "t_get_file failed at line: %d\n", __LINE__);
	++res;
    }
    free(fnptr);

    fnptr = get_file("cmnd -o");
    if (strcmp(fnptr, "cmnd") != 0) {
	fprintf(stderr, "t_get_file failed at line: %d\n", __LINE__);
	++res;
    }
    free(fnptr);

    fnptr = get_file("cmnd -o arg --option");
    if (strcmp(fnptr, "cmnd") != 0) {
	fprintf(stderr, "t_get_file failed at line: %d\n", __LINE__);
	++res;
    }
    free(fnptr);

    return res;
}
