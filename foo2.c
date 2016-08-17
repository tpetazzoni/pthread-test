#include <stdio.h>

void __attribute__((weak)) foo(void)
{
	printf("foo() from foo2\n");
}
