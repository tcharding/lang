#ifndef _TEST_H
#define _TEST_H

/* Macro to print test fail info */
#define FAIL(msg) \
    do {fprintf(stderr, "Failed test while: %s\n", msg); } while (0)

#endif /* _TEST_H */
