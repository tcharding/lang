#include <stdio.h>
#include <stdlib.h>

/* esh prototypes */
int esh_parse(char ***tokens, char *lptr);
void free_vector(char **tokens);
void print_vector(char **tokens);

/* test cases */
char *inputs[] = {
    "command",
    "command\n",
    " cmnd",
    "command --option -o",
    "cmnd \n -o",
    "cmnd 'quoted string'\n",
    "cmnd 'quoted string' arg\n",
    NULL
};

/*
 * Test esh parse function
 */

int main(int argc, char *argv[])
{
    char **tokens = NULL;
    char **iptr = inputs; /* ptr to global */
    int ret;
    int ntst = 0;
    int nerr = 0;

    /* pre-amble */
    printf("Testing parse() with the following lines of input\n\n");
    puts("START-INPUTS");
    for (iptr = inputs; *iptr != NULL; ++iptr) {
	printf("%s\n", *iptr);
    }
    puts("END-INPUTS\n");
    
    for (iptr = inputs ; *iptr != (char *)0; ++iptr) {
	ret = esh_parse(&tokens, *iptr);
	++ntst;
	if (ret < 0) {
	    fprintf(stderr, "Error parsing line: %s\n", *iptr);
	    free_vector(tokens);
	    ++nerr;
	    continue;
	}
    }
    printf("\nErrors reported: %d, Tests completed: %d\n", nerr, ntst);
}


int tst-isquote() 
{
    return 0;
}

int tst-free_vector()
{
    return 0;
}

