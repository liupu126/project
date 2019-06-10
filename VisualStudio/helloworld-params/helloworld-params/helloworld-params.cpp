#include <stdio.h>

int main(int argc, char* argv[])
{
	int i;
	printf("argc=%d\n", argc);

	for (i = 0; i < argc; i++)
	{
		printf("argv[%d]=%s\n", i, argv[i]);
	}

	printf("helloworld!\n");

	getchar();//avoid this program quit automatically
	return 0;
}