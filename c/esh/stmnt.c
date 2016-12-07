#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "esh.h"

#define EOS (char *)0 		/* End Of Statement */

/* Static Prototypes */
static struct stmnt *stmnt_init();
static char *next_token();
static struct cmnd *cmnd_init();
static struct cmnd *cmnd_add(struct cmnd *cmnd, char *token);
static void cmnd_print(struct cmnd *cmnd);
static void cmnd_print(struct cmnd *cmnd);
static void cmnd_free(struct cmnd *cmnd);

/**
 * Read statement from stdin.
 *
 * @return newly allocated memory containing statement read. Free with stmnt_free.
 */
struct stmnt *stmnt_read()
{
    /*char *global_prompt; global var not working */

    struct stmnt *stmnt;
    char *tok;
    char *prompt_ptr;

    /* prompt_ptr = global_prompt; */
    prompt_ptr = "MANUALLY SET: % "; /* hack */

    if (prompt_ptr == (char *)0) {
	perror("read_stmnt: prompt is not set");
	return NULL;
    }
    printf("%s", prompt_ptr);
    fflush(NULL);

    stmnt = stmnt_init();
    if (stmnt == NULL) {
	    perror("stmnt_read: stmnt_init error");
	    return NULL;
    }

    /* for now only implement stmnt->cmnd */
    while((tok = next_token()) != EOS) {
	/* only argv for now */
	if ((cmnd_add(stmnt->cmnd, tok)) == NULL) {
	    perror("stmnt_read: cmnd_add error");
	    return NULL;
	}
	free(tok);
    }
    return stmnt;
}
/**
 * Print statement stuct.
 */
void stmnt_print(struct stmnt *stmnt)
{
    printf("\nPrinting Statement\n\n");

    /* print var_list */
    printf("var_list: not yet implemented\n");

    /* print command */
    printf("cmnd: \n");
    if (stmnt->cmnd != NULL)
	cmnd_print(stmnt->cmnd);
    else
	printf("<NULL>\n");

    /* print in/out files */
    printf("infile: not yet implemented\n");
    printf("outfile: not yet implemented\n");
    
}
/**
 * Free statemnet
 */
void stmnt_free(struct stmnt *stmnt)
{
    /* TODO 
     *
     * free var_list
     */

    if (stmnt->cmnd != NULL) {
	cmnd_free(stmnt->cmnd);
    }

    if (stmnt->infile != (char *)0) {
	free(stmnt->infile);
    }
    if (stmnt->outfile != (char *)0) {
	free(stmnt->outfile);
    }

    free(stmnt);
}
/************************
 *
 * Functions private to this file
 *
 ************************/

/*
 * Allocate memory for statement and initialise members to NULL
 */
struct stmnt *stmnt_init()
{
    struct stmnt *stmnt;

    /* allocate memory for stmnt */
    if ((stmnt = malloc(sizeof(struct stmnt))) == NULL) {
	perror("malloc error");
	exit(1);
    }
    /* initialise members to NULL */
    stmnt->var_list = NULL;
    if ((stmnt->cmnd = cmnd_init()) == NULL) {
	perror("stmnt_init: cmnd_init error");
	return NULL;
    }
    stmnt->infile = (char *)0;
    stmnt->outfile = (char *)0;

    return stmnt;
}

/*
 * Parses stdin and returns next token or EOS if no tokens remain
 */
char *next_token()
{
    char *s;

    if ((s = malloc(2)) == NULL) {
	perror("malloc error");
	exit(1);
    }
    
    if ((*s = fgetc(stdin)) == EOF) {
	free(s);
	return EOS;
    }

    /* just one line at the momoent */
    if (*s == '\n') {
	free(s);
	return EOS;
    }

    *++s = '\0';
    
    return s; 			/* character read */
}

/*
 * Allocate memory for command
 */
struct cmnd *cmnd_init()
{
    struct cmnd *ptr;

    /* allocate memory for cmnd */
    if ((ptr = malloc(sizeof(struct cmnd))) == NULL) {
	perror("malloc error");
	exit(1);
    }
    
    /* initialise path to NULL */
    ptr->path = (char *)0;

    /* initialise argv */
    if ((ptr->vector = vector_init()) == NULL) {
	return NULL;
    }
    
    return ptr;
}
/*
 * Add token to cmnd->argv
 */
struct cmnd *cmnd_add(struct cmnd *cmnd, char *token)
{
    if (cmnd == NULL || token == NULL) 
	return NULL;

    if ((vector_add(cmnd->vector, token)) == NULL)
	return NULL;

    return cmnd;
}
/*
 * print statement command
 */
void cmnd_print(struct cmnd *cmnd)
{
    if (cmnd == NULL)
	return;
    
    /* print path */
    fprintf(stderr, " path: ");
    if (cmnd->path != NULL)
	fprintf(stderr, "%s\n", cmnd->path);
    else
	fprintf(stderr, "NULL\n");

    /* print cmnd vector */
    fprintf(stderr, " cmnd: ");
    vector_print(cmnd->vector, "* ** *");
}

void cmnd_free(struct cmnd *cmnd)
{
    /* free path */
    if (cmnd->path != (char *)0) {
	free(cmnd->path);
    }
    /* free argv */
    if (cmnd->vector != NULL) {
	vector_free(cmnd->vector);	
    }
}
