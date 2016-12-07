#include <stdlib.h>
#include <stdio.h>
#include "client.h"
#include "test.h"

static int tst_verbrose(void);
static int tst_foreach(void);

/* main: run verbrose tests */
int main(void)
{ 
    int failed = 0;

    if (tst_verbrose())
	++failed;

    if (tst_foreach())
	++failed;

    return failed;
}

int tst_foreach()
{
    void (*func)(struct client *clp) = &printcl;

    puts("Printing cltab with foreach()");
    foreach(func);
    return 0;
}

int tst_verbrose(void)
{
    int res;
    struct client cl1, cl2, cl3;

    puts("\nRunning verbrose tests ...\n");

    /* set up clients */
    cl1.name = "John";		/*  */
    cl1.addr = "john@gmail.com";

    cl2.name = "Bruce";
    cl2.addr = "bruce@gmail.com";

    cl3.name = "John";
    cl3.addr = "woo@bigin.com.au";

    /* test add */
    puts("Adding 3 clients");
    res = add((struct client *)0);
    if (res != -1)
	FAIL("Adding NULL to empty tab");

    res = add(&cl1);
    if (res != 1)
	FAIL("Adding first client");

    res = add((struct client *)0);
    if (res != -1)
	FAIL("Adding NULL to non-empty tab");

    res = add(&cl2);
    if (res != 2)
	FAIL("Adding second client");

    res = add(&cl3);
    if (res != 3)
	FAIL("Adding third client");
    
    dump();
    return 0;
}
