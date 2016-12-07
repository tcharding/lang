#ifndef _ESH_H
#define _ESH_H

#define DEBUG 1 /* set to 0 to turn off debugging */

/* macro to print error info */
#define esh_err(fmt, ...) \
    do {		      \
    fprintf(stderr, "esh: "); \
    fprintf(stderr, fmt, __VA_ARGS__); \
    } while (0)

struct cmnd {			/* command structure */
    char *path;
    char **argv;
};

/* stmnt.c */
struct cmnd *cmnd_init();
void cmnd_free(struct cmnd *cptr);

/* init.c */
int init();
char *set_prompt();

/* parse.c */
struct cmnd *parse(const char *input);

#endif	/* _ESTH_H */
