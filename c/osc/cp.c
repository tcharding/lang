#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int copy_file(char *src, char *dst);

int main(int argc, char *argv[])
{
    char *src = "in.txt";
    char *dst = "out.txt";
    int res;

    res = copy_file(src, dst);
    if (res < 0) {
	fprintf(stderr, "Error writing file\n");
	return(1);
    }
    return(0);
}

int copy_file(char *src, char *dst)
{
    FILE *in, *out;
    int c;

    if ((in = fopen(src, "r")) == NULL) {
	perror("can't open src file\n");
	exit(1);
    }
    if ((out = fopen(dst, "w+")) == NULL) {
	perror("can't open dst file\n");
	exit(1);
    }  

    c = fgetc(in);
    for (; c != EOF; c = fgetc(in)) {
	fputc(c, out);
    }
    return 0;
}
