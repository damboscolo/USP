#include "IdentificadorTeste.h"

void test1(void) {

	/* Escreva o codigo do teste 1 aqui */

}


/* Escreva os demais testes aqui */

int main(void) {

	CU_pSuite pSuite = NULL;

	if (CUE_SUCCESS != CU_initialize_registry())
		return CU_get_error();

	pSuite = CU_add_suite("CUnit Suite", NULL, NULL);
	if (NULL == pSuite) {
		CU_cleanup_registry();
		return CU_get_error();
	}

	if ((NULL == CU_add_test(pSuite, "test1", test1))
//		|| (NULL == CU_add_test(pSuite, "test2", test2))
//		|| (NULL == CU_add_test(pSuite, "test3", test3))
//		|| (NULL == CU_add_test(pSuite, "test4", test4))
//		|| (NULL == CU_add_test(pSuite, "test5", test5))
//		|| (NULL == CU_add_test(pSuite, "test6", test6))
//		|| (NULL == CU_add_test(pSuite, "test7", test7))
//		|| (NULL == CU_add_test(pSuite, "test8", test8))
//		|| (NULL == CU_add_test(pSuite, "test9", test9))
//		|| (NULL == CU_add_test(pSuite, "test10", test10))
	)
	{
		CU_cleanup_registry();
		return CU_get_error();
	}

	CU_automated_run_tests();

	CU_cleanup_registry();

	return CU_get_error();

}
