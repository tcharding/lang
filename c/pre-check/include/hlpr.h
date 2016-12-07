#ifndef _HLPR_H
#define _HLPR_H


/* macro to print debugging info */
#define PRINT(fmt, ...) \
            do { if (DEBUG) fprintf(stderr, fmt, __VA_ARGS__); } while (0)

/* macro to Test Fail Print information */
#define TFP(fn, ln, fnc, tc)						\
    do { fprintf(stderr, " Test Fail... %s, Line: %d, %s, %s", fn, ln, fnc, tc); 	\
    } while (0)

/*
 * Helper functions
 */

char *dupstr(const char *str);
void tlib_seq(char *file, int line, char *fn, (void *)(*fp)(char *), char *arg);

#endif /* _HLPR_H */




