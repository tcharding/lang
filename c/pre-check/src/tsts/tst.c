#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

/*
 * Run the test suite
 */

/* tst-hlpr.c */
int t_dupstr(int *cnt);

/* tst-init.c */
int t_set_prompt(int *cnt);
int t_init(int *cnt);

/* tst-stmnt.c */
int t_cmnd();

/* tst-parse.c */
int t_parse();
int t_get_file();
int t_get_path();

/* run the test suite */
int main(void)
{
    int tests = 0; 		/* total tests run */
    int fails = 0;		/* total tests failed */

    fprintf(stderr, "Running test suite ...\n\n");

    /* test hlpr.c */
    fails += t_dupstr(&tests);

    /* test init.c */
    fails += t_set_prompt(&tests);

    /* test stmnt.c */
    fails += t_cmnd(&tests);

    /* test parse.c */
    

    fprintf(stderr, "\n\nTotal Tests Run: %d\n", tests);
    fprintf(stderr, "Total Tests Failed: %d\n", fails);

    exit(0);
}

void run()
{
    START_TEST_SUITE

    START_TEST_FUNCTION "get_path"
    T_SEQ(get_path("ls"), "/usr/bin/ls");
    T_SEQ(get_path("shutdown.sh"), "/home/tobin/cloud/plain-text/code/bash/shutdown.sh");
    END_TEST_FUNCTION;

    START_TEST_FUNCTION "dupstr";
    T_SEQ(dupstr("test"), "test"); /* leaks memory */
    END_TEST_FUNCTION;
   
    

    END_TEST_SUITE;
}
