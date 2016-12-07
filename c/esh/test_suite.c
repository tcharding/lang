#include <stdlib.h>
#include <check.h>
#include "esh.h"

/* suite prototypes */
Suite *init_suite(void);
Suite *hlpr_suite(void);
Suite *stmnt_suite(void);

int main(void)
{
    int number_failed;
    SRunner *sr;

    sr = srunner_create(NULL);

    srunner_add_suite(sr, init_suite());
    srunner_add_suite(sr, hlpr_suite());
    srunner_add_suite(sr, stmnt_suite());
    
    srunner_run_all(sr, CK_NORMAL);
    number_failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
