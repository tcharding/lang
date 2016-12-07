#include <stdlib.h>
#include <stdio.h>

void bubble_sort(int *array, int n);
void print_array(int *array, int n);

int main(void)
{
    int dummy[] = { 3, 2, 5, 1 };

    printf("Initial Array\n");
    print_array( dummy, 4 );
    bubble_sort( dummy, 4 ); 
    printf("Sorted Array\n");
    print_array( dummy, 4 );

    return 0;
}

void print_array(int *array, int n)
{
    int i;
    
    for( i = 0; i < n; i++) 
        printf("%d ", *(array + i));
    printf("\n");
}

void bubble_sort(int *array, int n)
{
    int i, j, tmp;

    for( i = 0; i < n; i++)
        for( j = 0; j < n-1; j++)
            if( *(array + j) > *(array + j + 1) ) {
                tmp = *(array + j);
                *(array + j) = *(array + j + 1);
                *(array + j + 1) = tmp;
            }
}
