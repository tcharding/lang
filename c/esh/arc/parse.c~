#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*
 * parse string lptr into vector of vector of strings
 *
 * Return: NULL terminated vector or NULL on error
 *   free newly allocated memory with lgnt_v_free()
 */
char **esh_parse(const char *lptr) 
{
    char **tokens = NULL; /* pointer for tokens */
    int ntkns = 0; /* number of tokens */
    char *c; /* current character */
    char *tptr; /* new token */

    c = lptr; /* start at begining of lptr */

    while ( (tptr = next_token(&c) ) != NULL) { /* parse loop */
	ret = lgnt_v_append(tokens, tptr, ntkns);
	++ntkns;
    }
    return tokens;
}

enum { NO , SINGLE, DOUBLE }; /* quote character */

/*
 * get token
 *
 * on return *start is set to last character of token 
 *    ie NULL or start of next token
 *
 * Return: newly allocated memory containing token
 */
char *next_token(char **start) {
    quote_t quote = NO; 
    char *ts = NULL; /* token start */
    char *tf = NULL; /* token finnish */
    char *c; /* current character */

    c = lptr; /* start at beginning of line */
    /* skip initial white space */
    while (isspace(*c))
        ++c;
    return NULL;
}

    if ( (quote = isquote(*c)) ) { /* quoted token */
        ++c;
	ts = c;
	while ( isquote(*c) != quote) {
	    ++c;
	}
	tf = c; /* token finish points at ending quote */
	ret = segment_to_vector(tokens, ts, tf);
	if (ret < 0) {
	    perror("esh_parse: segment_to_vector failed");
	    /* TODO clean up */
	    return NULL;
	}
	++c;
    }

    return ntkns;
}

/* tokens is NULL terminated */
void free_vector(char **tokens) 
{
    char *tmp;

    if (tokens == NULL) 
	return;
	
    while (*tokens != NULL) {
	tmp = *tokens;
	++tokens;
	free(tmp);
    }

    free (tokens);
}

/*
 * tokens is NULL terminated
 */ 
void print_vector(char **tokens)
{
    if (tokens == NULL || *tokens == NULL) {
	return; /* error */
    }

    printf("START-TOKENS-- \n");
    for ( ; *tokens != NULL; ++tokens) {
	printf("%s\n", *tokens);
    }
    printf("END-TOKENS-- \n");
}
