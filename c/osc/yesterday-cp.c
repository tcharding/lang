#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define MAX 80

int main(int argc, char *argv[])
{
    char buf[MAX], *p;
    char *src = NULL;
    char *dst = NULL;
    size_t len = 0;
    ssize_t read;
    FILE *src_fp, *dst_fp;
    int c;
    
    /* prompt for input and output files */
    printf("Enter source file: ");
    fflush(stdout);
    p = fgets(buf, MAX, stdin);
    if (p == NULL) {
	fprintf(stderr, "Cannot read src file"); 
	exit(0);
    }
    
    scanf("%s", src);

    /* if ((read = getline(&src, &len, stdin)) == -1) { */
    /* 	fprintf(stderr, "Cannot get src file"); */
    /* 	exit(EXIT_FAILURE); */
    /* } */
    printf("Enter destination file: ");

    if ((read = getline(&dst, &len, stdin)) == -1) {
	fprintf(stderr, "Cannot get dst file");
	exit(EXIT_FAILURE);
    }
    printf("src: %s\n", src);
    /* open files */
    if ((src_fp = fopen(buf, "r")) == NULL) {
	fprintf(stderr, "Cannot open file: %s\n", src);
	exit(EXIT_FAILURE);
    }
    if ((dst_fp = fopen(dst, "w")) == NULL) {
	fprintf(stderr, "Cannot open file: %s\n", dst);
	exit(EXIT_FAILURE);
    }
    /* do copy */
    while((c = fgetc(src_fp)) != EOF) {
	fputc(c, dst_fp);
    }

    free(src);
    free(dst);
    exit(EXIT_SUCCESS);
}
