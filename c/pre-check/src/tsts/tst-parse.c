#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "hlpr.h"

enum {NO, YES} predicate;

char *fn = "tst-parse.c";

/* prototypes to test */
struct cmnd *parse(const char *input);
char *get_file(const char *input);
char *get_path(const char *input);

/* tests */
int t_parse();
int t_get_file();
int t_get_path();

int t_get_path(char *cnt)
{
    START_TEST_FUNCTION "get_path"
    T_SEQ(get_path("ls"), "/usr/bin/ls");
    T_SEQ(get_path("shutdown.sh"), "/home/tobin/cloud/plain-text/code/bash/shutdown.sh");
    END_TEST_FUNCTION
    

    ++*cnt;
    tc = "ls";
    ptr = get_path(tc);
    if(strcmp(ptr, "/usr/bin/ls") != 0) {
	TFP(__FILE__, __LINE__, fnc, tc);
	++res;
    }
    free(ptr);

    /* TODO add more test cases */

    return res; 
}
int is_argv0(struct cmnd *cptr, char *file)
{
/*
    if (cptr == NULL)
	return NO;
    if (cptr->argv == NULL)
	return NO;
    if (*(cptr->argv) == NULL)
	return NO;
    if ((strcmp(*(cptr->argv), cmnd)) == 0)
	return YES;
*/
    return NO;
}
int t_parse()
{
    
    int res = 0;
    /*
    char *fn = "t_parse";
    char *tc;
    struct cmnd *ptr;

    tc = "cmnd";
    ptr = parse(tc);
    if (ptr == NULL)
	TFP(fn, tc, __LINE__);
    if (VERBROSE)
	cmnd_prnt(ptr);
    if (!is_argv0(tc, ptr))
	TFP(fn, tc, __LINE__);
    */
    return res;
}

void t_get_file_hlpr (char *tc, int *cnt, int ln)
{    

}

int t_get_file()
{
    return 0;
}
