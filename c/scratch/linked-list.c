#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define NUM 5 /* number of nodes */
#define LENGTH 128 /* max title length */
#define DEBUG 0 /* set to 0 to turn off debugging */

/* macro to print debugging info */
#define debug_print(fmt, ...) \
            do { if (DEBUG) fprintf(stderr, fmt, __VA_ARGS__); } while (0)

struct node {
    char *title;
    struct node *next;
};

/* prototypes */
struct node *create_node(const char *title);
void free_node(struct node *node);
struct node *add_to_list(struct node *head, struct node *nptr);
void print_node(struct node *nptr);
void print_list(struct node *head);
void free_list(struct node *head);

/* 
 * Demo use of linked list 
 */
int main(int argc, char *argv[]) 
{
    struct node *head = NULL; /* linked list */
    struct node *nptr; /* node pointer */
    int i, res;
    char title[LENGTH];

    /* add some nodes */
    printf("Creating %d nodes...\n", NUM);
    for (i = 0; i < NUM; ++i) {
	res = sprintf(title, "Node: %d", i); /* sloppy: no boundry checking */
	if (res < 0) {
	    perror("main: sprintf failed");
	    exit(1);
	}

	debug_print("debug: title string is: %s\n", title); 

	nptr = create_node(title);
	if (nptr == NULL) {
	    perror("main: create_node");
	    exit(1);
	} 

	head = add_to_list(head, nptr);
	if (res < 0) { 
	    perror("main: add_to_list failed");
	    exit(1);
	}
    }
    
    /* lets print out the nodes to confirm things are working */
    puts("Printing linked list");
    print_list(head);
    

    /* free nodes */
    free_list(head);
}
/*
 * allocate memory and create new node
 *
 * returns new node or NULL on error
 */
struct node *create_node(const char *title) 
{
    struct node *nptr;

    /* allocate memory for node */
    nptr = malloc(sizeof(struct node *));
    if (nptr == NULL) {
	perror("create_node: malloc error");
	return NULL;
    }

    /* allocate memory within node for title */
    nptr->title = malloc( strlen(title) + 1 ); /* +1 for null character */
    if (nptr->title == NULL) {
	free(nptr); 		/* must free memory from previous call to malloc */
	perror("create_node: malloc error");
	return NULL;
    }
    /* set up node data */
    strcpy(nptr->title, title);	/* copy title */
    nptr->next = NULL; 		/* initialise next to NULL */

    return nptr;
}
/*
 * add nptr to list head
 *
 * return list head
 */
struct node *add_to_list(struct node *head, struct node *nptr) {
    struct node *end = head;
    
    if (head == NULL) {		/* empty list */
        return nptr;
    } else {			/* seek to end of list */
	while(end->next != NULL) 
	    end = end->next;
	/* add node */
	end->next = nptr;
    }
    return head;
}
void print_list(struct node *head)
{
    while(head != NULL) {
	print_node(head);
	head = head->next;
    }
    debug_print("%s", "END OF LIST\n");
}
/*
 *
 */
void print_node(struct node *nptr) {
    /* whatever you want here */
    printf("%s\n", nptr->title);
}
/*
 * free the whole list
 */
void free_list(struct node *head)
{
    struct node *tmp;

    while(head != NULL) {
	tmp = head->next;
	free_node(head);
	head = tmp;
    }
}
/* 
 * free node memory
 */
void free_node(struct node *nptr)
{
    free(nptr->title);		
    free(nptr);
}
