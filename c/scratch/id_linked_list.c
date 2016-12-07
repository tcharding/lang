#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <string.h>

enum BOOL { ON, OFF };

#define NUM 2
#define DEBUG ON
#define VERBROSE ON

/* linked list NODE */
typedef struct node {
    char *name;
    char *number;
/*    struct id *previous; */
    struct node *next;
} NODE;

/* NODE specific prototypes */
NODE *create_node(const char *name, const char *number);
void free_node(NODE *node);
void print_node(NODE *node);
NODE *create_from_stdin();
int compare_nodes(NODE *first, NODE *second);

/* linked list prototypes (generic to any NODE) */
NODE *follow_list(NODE *list);
NODE *add_node(NODE *head, NODE *node);
/* NODE *remove_node(NODE *node); */
void free_list(NODE *head);
NODE *visit_each_node(NODE *head, NODE **current);

/* test suite */
int tst_node_specific();
int tst_list();
int tst_compare_nodes();


int main(int argc, char *argv[])
{    
    
/* run test suite */
#ifdef DEBUG
    int res;
    
    printf("Running test suite\n\n");

    /* tst_node_specific */
    res = tst_node_specific();
    if (res != 0) {
	printf("FAILED: node specific tests\n");
    }
    if (res == 0 && VERBROSE == ON) 
	printf("node specific tests ...... OK\n");	
    
    /* tst_compare_nodes() */
    res = tst_compare_nodes();
    if (res != 0) {
	printf("FAILED: compare tests (test: %d)\n", res);
    }
    if (res == 0 && VERBROSE == ON) 
	printf("compare nodes tests ...... OK\n");	
    
    /* tst_list */
    res = tst_list();
    if (res != 0) {
	printf("FAILED: list tests (test: %d)\n", res);
    }
    if (res == 0 && VERBROSE == ON) 
	printf("list tests ...... OK\n");	
    
    exit(EXIT_SUCCESS);
#endif

/* main program */
    NODE *head = NULL; /* id linked list */
    NODE *new;
    NODE **current = NULL;
    int i;

    for (i = 0; i < NUM; i++) {
	if ((new = create_from_stdin()) == NULL) {
	    perror("can't create node");
	    exit(EXIT_FAILURE); 
	}
        if ((add_node(head, new)) == NULL) {
	    perror("can't add node");
	    exit(EXIT_FAILURE); 
	}
    }

    /* print list */
    while (visit_each_node(head, current) != NULL)
	print_node(*current);

    free_list(head);
    exit(EXIT_SUCCESS);
}

/* 
 * create new id
 *
 * creates new copy of name and number using strcpy() 
 * must be free'd with free_id()
 */
NODE *create_node(const char *name, const char *number)
{
    NODE *node;
    
    /* allocate memory for an id */
    if ((node = (NODE *)malloc(sizeof(NODE))) == NULL)
	return NULL;

    /* allocate memory for and copy name */
    if ((node->name = (char *)malloc(strlen(name)+1)) == NULL) {
	free(node);
	return NULL;
    }
    strcpy(node->name, name);
    
    /* allocate memory for and copy number */
    if ((node->number = (char *)malloc(strlen(number)+1)) == NULL) {
	free(node->name);
	free(node);
	return NULL;
    }
    strcpy(node->number, number);
    
    node->next = NULL;
    return node;
}
void free_node(NODE *node)
{
    if (node == NULL)
	return;

    free(node->name);
    free(node->number);
    free(node);
}
void print_node(NODE *node)
{
    if (node == NULL)
	return;

    printf("Name: %s\nNumber: %s\n\n", node->name, node->number);
}
/*
 * compare two nodes
 *
 * nodes are compared alphabetically on 'name'
 * returs 0 if either node is NULL
 */
int compare_nodes(NODE *first, NODE *second)
{
#ifdef DEBUG
    if (first == NULL || second == NULL)
	printf("NULL parameter passed to compare_nodes()\n");
#endif

    if (first == NULL || second == NULL)
	return 0;
    
    return (strcmp(first->name, second->name));
}

/*
 * Prompt user for inputs and create struct id
 *
 * returned id must be free'd with free_id()
 */
NODE *create_from_stdin()
{
    NODE *new;
    char *name = NULL;
    char *number = NULL;
    size_t len = 0;
    ssize_t read; 
  
    printf("Enter name: ");
    if ((read = getline(&name, &len, stdin)) == -1) { 
	perror("getline name error");
	return NULL;
    }
    printf("Enter number: ");
    if ((read = getline(&number, &len, stdin)) == -1) { 
	free(name);
	perror("getline number error");
	return NULL;
    }
    /* strip new lines */
    len = strlen(name) - 1;
    if (name[len] == '\n')
	name[len] = '\0';

    len = strlen(number) - 1;
    if (number[len] == '\n')
	number[len] = '\0';

    if ((new = create_node(name, number)) == NULL) {
	free(name);
	free(number);
	perror("could not create node");
	return NULL;
    }
    free(name);
    free(number);
    return new;
}

/* NODE linked list prototypes */
NODE *follow_list(NODE *list)
{
    if (list == NULL)		/* invalid call */
	return NULL;
    
    while (list->next != NULL)
	list = list->next;
    
    return list;
}
/*
 * Add node to list
 *
 * head may be NULL
 */
NODE *add_node(NODE *head, NODE *node)
{
    NODE *tail;
    
    if (node == NULL)		/* invalid call */
	return NULL;
    
    if (head == NULL) {
        return node;
    } else {
	/* tail = follow_list(head); */
	/* tail->next = node; */
	head->next = node;
    }    
    return head;
}
/* TODO only implement after preivous is added to node */
NODE *remove_node(NODE *node)
{
    if (node == NULL)
	return NULL;
    
    return NULL;
}
void free_list(NODE *head)
{

}
/*
 * Traverse a list 
 *
 * On first call 'current' must be NULL. After call, and on each
 * subsequent call, 'current' is set to next node
 *
 * Returns NULL when list has been fully traversed
 */
NODE *visit_each_node(NODE *head, NODE **current)
{
    NODE *next, *tmp;

    if (head == NULL)		/* invalid call */
	return NULL;
    
    if (current == NULL) { /* first call */
	printf("first call\n");
	*current = head;
    } else {			/* subsequent calls */
	tmp = *current;
	next = tmp->next;
	*current = next;
    }
    return *current;
}

int tst_node_specific()
{
    NODE *new;
    
    /* test create_node */
    new = create_node("Tobin Harding", "(02) 1238 1239");
    if (new == NULL)
	return 1;

    /* test print_node */
    if (VERBROSE == ON) {
	print_node(new);
    }
    /* test free_node */
    free_node(new);

    /* test create_from_stdin */
/*
    new = create_from_stdin();
    if (VERBROSE == ON) {
	print_node(new);
    }
    free_node(new);
*/

    return 0;
}
int tst_compare_nodes()
{
    NODE *one, *two, *three, *same;
        
    one = create_node("One", "123");
    two = create_node("Two", "456");
    three = create_node("Three", "789");
    same = create_node("One", "123");

    if (!(compare_nodes(one, two) < 0)) /* one is less than two */
	return 1;
    if (!(compare_nodes(two, three) > 0)) /* two is not less than three */
	return 2;
    if (!(compare_nodes(two, one) > 0)) /* two is greater than one */
	return 3;
    if (!(compare_nodes(three, two) < 0)) /* three is not greater than two */
	return 4;
    if (!(compare_nodes(one, same) == 0)) /* one is same as same */
	return 5;
    if (!(compare_nodes(one, two) != 0)) /* one is not the same as two */
	return 6;
    
    free_node(one);
    free_node(two);
    free_node(three);
    free_node(same);
    return 0;
}

int tst_list()
{
    NODE *head = NULL;
    NODE *one, *two, *tail;
    NODE **current = NULL;	/* visit_each_node() */
    
    one = create_node("One", "123");
    two = create_node("Two", "456");
    
    /* /\* test add_node *\/ */
    head = add_node(head, one); 
    if ((compare_nodes(head, one)) != 0)
    	return 1;
    
    /* test follow_node */
    tail = follow_list(head); /* test with one node */
    if ((compare_nodes(tail, one)) != 0)
    	return 2;

    /* add another node and repeat tests */
    if (add_node(head, two) == NULL)
	return 31;
    /* if ((compare_nodes(head, one)) != 0) /\* check head has not been touched *\/ */
    /* 	return 3; */
    /* tail = follow_list(head); /\* test with two node *\/ */
    /* if ((compare_nodes(tail, two)) != 0) */
    /* 	return 4; */
    /* if ((compare_nodes(head, one)) != 0) /\* check head has not been touched *\/ */
    /* 	return 5; */

    /* /\* test visit_each_node *\/ */
    /* if (VERBROSE == ON) { */
    /* 	printf("Printing each node\n\n"); */
    /* 	current = NULL; */
    /* 	if (head == NULL) */
    /* 	    printf("null\n"); */
    /* 	while ((visit_each_node(head, current)) != NULL) { */
    /* 	    printf("In tst_list(visit_each_node)\n"); */
    /* 	    print_node(*current); */
    /* 	} */
    /* } */
    /* test free_list */
    /* free_list(head); */
    
    return 0;
}
