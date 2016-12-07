#include <stdlib.h>
#include <check.h>

/* Function prototypes */


START_TEST (t_)
{

}
END_TEST

Suite *stmnt_suite(void)
{
    Suite *s;
    TCase *tc_core;

    s = suite_create("Statement");

    /* Core test case */
    tc_core = tcase_create("Core");
    tcase_add_test(tc_core, t_);

    suite_add_tcase(s, tc_core);
    return s;
}
