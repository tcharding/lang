#ifndef _ESH_H
#define _ESH_H

#define DEBUG 1 /* set to 0 to turn off debugging */

/* Macro to print debugging info */
#define PRINT(fmt, ...) \
            do { if (DEBUG) fprintf(stderr, fmt, __VA_ARGS__); } while (0)

#define DP(fmt, ...) if (DEBUG) fprintf(stderr, fmt, __VA_ARGS__);

/* Macro to print shell error msg to user */
#define esh_err(fmt, ...) \
    do {		      \
    fprintf(stderr, "esh: "); \
    fprintf(stderr, fmt, __VA_ARGS__); \
    } while (0)

#define VBS 255		/* vector array block size */
struct vector {			/* variable size vector */
    size_t size;
    int cnt;
    char **v;
};

struct cmnd {			/* argv */
    char *path;
    struct vector *vector;
};

struct stmnt {
    char **var_list; 		/* vector of strings of form VAR=val */
    struct cmnd *cmnd;
    char *infile;		/* redirection */
    char *outfile;
};

extern char *global_prompt;	/* global prompt string */

/* stmnt.c */
struct stmnt *stmnt_read();
void stmnt_print(struct stmnt *stmnt);
void stmnt_free(struct stmnt *stmnt);

/* init.c */
int init();
char *prompt();

/* hlpr.c */
char *strdup (const char *s);
struct vector *vector_init();
struct vector *vector_add(struct vector *vector, const char *s);
void vector_print(struct vector *vector, char *delim);
void vector_free(struct vector *vector);

#endif	/* _ESTH_H */
