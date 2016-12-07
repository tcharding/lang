#ifndef _CLIENT_H
#define _CLIENT_H

#define DEBUG 1

/* Macro to print debugging info */
#define PUT(fmt, ...) \
            do { if (DEBUG) fprintf(stderr, fmt, __VA_ARGS__); } while (0)

struct client {
    char *name; 
    char *addr;			/* email address */
};

/* store.c */
extern int add(struct client *clp); /* add client to cltab */
extern struct client *clbyname(const char *name); /* get client by name */
extern struct client *clbyaddr(const char *addr); /* get client by address */
void dump();			/* dump all clients to stdout */
/* TODO: add function to allow function call for each client */


/* client.c */
extern struct client *newcl(const char *name, const char *addr); 
extern void freecl(struct client *clp);
extern void printcl(struct client *clp);


/**** testing *****/

/* Macro to print test fail info */
#define FAIL(msg) \
    do {fprintf(stderr, "Failed test while: %s\n", msg); } while (0)

/* tst-store.c */
void tst_add(void);
void tst_clby(void);



#endif /* _CLIENT_H */
