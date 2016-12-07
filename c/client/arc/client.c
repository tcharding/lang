#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

struct client {
    char *name;			/* client name */
    char *addr;			/* email address */
    int num;			/* client number */
};

struct client_tab {
    int num;			/* current number of entries */
    int max;			/* allocated capacity */
    struct client *cls;		/* client array */
} cltab;

enum { 
    INIT = 1,			/* initial array size */
    GROW = 2 			/* array resize factor */
};

static struct client *newcl(const char *name, const char *addr); 
static int gen_clnum(void);		    /* generate unique client number */
static void freecl(struct client *clp);
static void printcl(struct client *clp);

static int addcl(struct client *clp);       /* add client to cltab */
static struct client *clbyname(const char *name); /* get client by name */
static struct client *clbyaddr(const char *addr); /* get client by address */
static struct client *clbynum(int num);		  /* get clien by number */
static void dump(void);				  /* print client list */

/* newcl: create new client, free with freecl() */
struct client *newcl(const char *name, const char *addr)
{
    struct client *clp;

    if (clbyname(name) != NULL) {		/* assert name unique */
	fprintf(stderr, "Name %s already exists", name);
	return NULL;
    }
    if (clbyaddr(addr) != NULL) {		/* assert addr unique */
	fprintf(stderr, "Address %s already exists", addr);
	return NULL;
    }

    clp = malloc(sizeof(struct client));
    if (clp == NULL) 
	return NULL;

    /* copy name to clp */
    clp->name = malloc(strlen(name)+1);
    if (clp->name == NULL)
	return NULL;
    strcpy(clp->name, name);	

    /* copy addr to clp */
    clp->addr = malloc(strlen(addr)+1);
    if (clp->addr == NULL)
	return NULL;
    strcpy(clp->addr, addr);

    clp->num = gen_clnum();	/* set unique client number */
    return clp;
}

/* gencl_num: generate unique client number */
int gen_clnum(void)
{
    int n;
    time_t t = time(0);

    do {
	srand(t);
	n = rand() & 0xff;
    } while (clbynum(n) != NULL);
    
    return n;
}

/* freecl: free clp */
void freecl(struct client *clp)
{
    free(clp->name);
    free(clp->addr);
    free(clp);
}

/* printcl: print clp */
void printcl(struct client *clp)
{
    printf("%s (0x%x) %s\n", clp->name, clp->num, clp->addr);
}

/* addcl: add clp to cltab, return total number of clients */
int addcl(struct client *clp)
{
    struct client *mem;

    if(cltab.cls == NULL) {	/* first time */
	cltab.cls = malloc(INIT * sizeof(struct client));
	if (cltab.cls == NULL)
	    return -1;
	cltab.num = 0;
	cltab.max = INIT;
    } else if (cltab.num >= cltab.max) { /* grow */
	mem = realloc(cltab.cls, (GROW * cltab.max) * sizeof(struct client));
	if (mem == NULL)
	    return -1;
	cltab.max *= GROW;
	cltab.cls = mem;
    }
    cltab.cls[cltab.num] = *clp;
    return ++cltab.num;
}

/* clbyname: get client by name from cltab, return NULL if not found */
struct client *clbyname(const char *name)
{
    struct client *clp = cltab.cls;
    int i;

    for (i = 0; i < cltab.num; i++) {
	if (strcmp(clp->name, name) == 0)
	    return clp;
	clp++;
    }
    return NULL;		/* not found */
}

/* clbyaddr: get client by addr from cltab, return NULL if not found */
struct client *clbyaddr(const char *addr)
{
    struct client *clp = cltab.cls;
    int i;

    for (i = 0; i < cltab.num; i++) {
	if (strcmp(clp->addr, addr) == 0)
	    return clp;
	clp++;
    }
    return NULL;		/* not found */
}

/* clbynum: get client by num from cltab, return NULL if not found */
struct client *clbynum(int num)
{
    struct client *clp = cltab.cls;
    int i;

    for (i = 0; i < cltab.num; i++) {
	if (clp->num == num)
	    return clp;
	clp++;
    }
    return NULL;		/* not found */
}

/* dump: print client list to stdout */
void dump(void)
{
    struct client *clp = cltab.cls;
    int i;

    printf("Dumping cltab:\n");
    for (i = 0; i < cltab.num; i++) {
	printf("\t");
        printcl(clp);
	clp++;
    }
    printf("\n");
}

/* main: test client implementation */
int main (int argc, char *argv[])
{
    struct client *clp;
    int res = 0;

    printf("Testing client\n");

    puts("Creating: Tom, tom@blooz.net");
    clp = newcl("Tom", "tom@blooz.net");
    if (clp == NULL) {
	return -1;
    }
	
    puts("Adding Tom to cltab and dumping");
    res = addcl(clp);
    if (res != 1) {
	puts("addcl error");
	printf("num: %d\n", res);
	exit(1);
    }
    dump();

    puts("testing clby..");

    clp = clbyname("Tom");
    printcl(clp);
  

    clp = clbyaddr("tom@blooz.net");
    printcl(clp);
    
    clp = clbyname("aoeu");
    if (clp != NULL)
	puts("clbyname error");
    clp = clbyaddr("aoeu");
    if (clp != NULL)
	puts("clbyaddr error");

    clp = newcl("tim", "tim@shirtsoff.com");
    printcl(clp);

    exit(0);

    if (clp == NULL)
	return -1;
    res = addcl(clp);
    printf("res: %d\n", res);
    if (res != 2) {
	puts("addcl error");
	exit(1);
    }


/*  

    puts("Adding tim and mary");

    clp = newcl("tim", "tim@shirtsoff.com");
    printcl(clp);

    if (clp == NULL)
	return -1;
    res = addcl(clp);
    printf("res: %d\n", res);
    if (res != 2) {
	puts("addcl error");
	exit(1);
    }

    clp = newcl("mary", "mary@test.com");
    printcl(clp);

    if (clp == NULL)
	return -1;
    res = addcl(clp);
    if (res != 3) {
	puts("addcl error");
	exit(1);
    }
    puts("almost done");
    dump();
    */
    freecl(clp); /* stop the compiler complaining about this */
    exit(0);
}
