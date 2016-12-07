#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <string.h>
#include "esh.h"

/*
 * Helper functions
 */ 

void vector_resize(struct vector *vector);

char *strdup (const char *s)
{
    char *d;

    if (s == NULL) 
	return NULL;

    d = malloc (strlen(s) + 1); /* + 1 for NULL */
    if (d == NULL) 
	return NULL;		/* no memory left */
    strcpy (d,s);             

    return d;                     
}

/**
 * Initialiase a NULL terminated vector of strings
 */
struct vector *vector_init()
{
    struct vector *vector;

    /* allocate memory for struct */
    if ((vector = malloc(sizeof(struct vector))) == NULL) {
	perror("malloc error");
	exit(1);
    }

    /* allocate memory for internal vector */
    vector->v = malloc((VBS+1) * sizeof(char *));
    if (vector->v == NULL) { 
	free(vector);
	perror("malloc error");
	exit(1);
    } 

    vector->size = VBS;		/* initial size */
    vector->cnt = 0;		/* initially empty */
    *(vector->v) = (char *)0;	/* NULL first element */

    return vector;
}

/**
 * Add string to end of vector
 * 
 * @returns vector. You must reasign with returned pointed
 */
struct vector *vector_add(struct vector *vector, const char *s)
{
    char **vp;

    /* error check */
    if (vector == NULL || s == NULL || *s == '\0')
	return NULL;

    /* relloc if necessary */
    if (vector->cnt >= vector->size) 
        vector_resize(vector); /* vector_resize exits on error */	

    vp = vector->v;
    while(*vp != NULL)
	++vp;			/* seek to end of vector */
    *vp = strdup(s);
    ++vp;
    *vp = (char *)0;
    ++(vector->cnt);

    return vector;
}
/**
 * Print Vector
 *
 * @params delim, string delimeter seperating elements of vector
 */
void vector_print(struct vector *vector, char *delim)
{
    char **vp;

    if (vector == NULL)
	return;

    if (delim == (char *)0)
	delim = " ";		/* set delimiteter if passed in NULL */

    vp = vector->v;
    while (*vp != (char *)0) {
	printf("%s", *vp);
	printf("%s", delim);
	++vp;
    }
    printf("<NULL>");
}

/**
 * Free Vector
 */
void vector_free(struct vector *vector)
{

    char **tv;			/* temp vector */
 

    if (vector == NULL)
	return;

    if (vector->v == NULL) {
	free(vector);
	return;
    }

    tv = vector->v;
    while (*tv != (char *)0) {
/*	ts = *tv;*/
/*	free(ts); */
	++tv;
    }
/*
   free(vector->v);
   free(vector);*/
}
/*
 *
 * NOT WORKING
 */
/*
 * Changes the size of the memory block pointed to by vector->v
 */
void vector_resize(struct vector *vector)
{
    size_t size;
    char **new;
    
    size = vector->size + 1 + VBS; /* old size + NULL + vector block size */
    new = realloc(vector->v, size);
    if (new == NULL) {
	perror("realloc error");
	exit(1);		/* exit since we can't handle realloc error here */
    }
    
    vector->v = new;
}
