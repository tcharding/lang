#include <stdlib.h>
#include <stdio.h>
#include <check.h>
#include "esh.h"

#define VERBROSE 1

START_TEST (t_strdup)
{
    char *str = NULL;
    char *tc;

    tc = "string";
    str = strdup(tc);
    ck_assert_str_eq(str, tc);
    free(str);

    tc = "more \n complicated";
    str = strdup(tc);
    ck_assert_str_eq(str, tc);
    free(str);
}
END_TEST

/****
 * NOTE - set VBS (in esh.h) to 1 to test memory allocation (vector_resize)
 */
START_TEST (t_vector)
{
    struct vector *vector;

    vector = vector_init();
/*    ck_assert((vector = vector_init()) != NULL);*/
    vector_add(vector, "One");
    ck_assert((strcmp(*vector->v, "One")) == 0);
    vector_add(vector, "Flew");
    vector_add(vector, "Over"); 
    if (VERBROSE) {
	vector_print(vector, NULL);
	printf("\n");
    }
    if (VERBROSE) {
	vector_print(vector, "* ** *");
	printf("\n");	
    }

    vector_free(vector);
}
END_TEST

Suite *hlpr_suite(void)
{
    Suite *s;
    TCase *tc_core;

    s = suite_create("Hlpr");

    /* Core test case */
    tc_core = tcase_create("Core");
    tcase_add_test(tc_core, t_strdup);
    tcase_add_test(tc_core, t_vector);

    suite_add_tcase(s, tc_core);
    return s;
}
