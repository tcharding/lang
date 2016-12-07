#include <stdlib.h>
#include <stdio.h>

/* 
 * function prototypes
 */
int compare(void *, void *); /* compare two items */
void swap(void *a, void *b); /* swap generic items */
void bubble_sort(void *array, int n, void (*swap_func)(void *, void *)); /* sort generic array */
void print_array(void *array, int n, void (*print_func)(void *)); /* print generic array */
void print_item(void *); /* generic print function prototype */

/***********
 * Generic Array Functions
 */
void print_array(int *array, int n, void (*print_func)(void *))
{
    int i;
    
    for( i = 0; i < n; i++) 
        (*print_func)(array[i]);
    printf("\n");
}

void bubble_sort(void *array, int n, void (*swap_func)(void *, void *))
{
    int i, j;

    for( i = 0; i < n; i++)
        for( j = 0; j < n-1; j++)
            if( compare( array[j], array[j+1] )
                (*swap_func(array[j], array[j+1]))n
}


/***********
 * Integer Array Functions
 */
void swap_int(int *a, int *b)
{
    int tmp;

    tmp = *a;
    *a = *b;
    *b = tmp;
}
/***********
 * test suite
 */
void test_int_array()
{
    int dummy[] = { 3, 2, 5, 1 };

    printf("Initial Array\n");
    print_array( dummy, 4 );
    bubble_sort( dummy, 4 ); 
    printf("Sorted Array\n");
    print_array( dummy, 4 );
}
/***********
 * Main
 */
int main(void)
{
    test_int_array();

    return 0;
}
