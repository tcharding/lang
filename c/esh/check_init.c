#include <stdlib.h>
#include <stdio.h>
#include <check.h>

char *prompt();

START_TEST (t_prompt)
{
    char *ptr = NULL;

    fail_if((ptr = prompt()) == NULL);
    ck_assert_str_eq(ptr, "esh % ");

    free(ptr);
}
END_TEST

Suite *init_suite(void)
{
    Suite *s;
    TCase *tc_core;

    s = suite_create("\n Init"); /* \n - dirty hack to fix output from check */

    /* Core test case */
    tc_core = tcase_create("Core");
    tcase_add_test(tc_core, t_prompt);

    suite_add_tcase(s, tc_core);
    return s;
}
