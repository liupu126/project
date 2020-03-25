/****************************************************************************
* Copyright: 2016-2017, Xxxxxx Technology Co., Ltd.
* File Name: test.c
* Description:
* 	Test & Check C functions & the others in Linux enviroment.
*	usage:
*		gcc -o test test.c
*		./test
* Author:
*	Braden Liu, liupu126@126.com
* Version:	None
* History:
*	2017-10-16	Braden Liu	1st Release
*		1. Create file.
****************************************************************************/
#include <stdio.h>
#include <string.h>

void string_process_function(void)
{
	// strchr & strrchr
	const char* str1 = "I_love_you!";
	printf("strchr: %s, strrchr: %s\n", strchr(str1, '_'), strrchr(str1, '_'));
	
	// 
	char str2[10] = {0};
	const int INT_2 = 2; // 2
	sprintf(str2, "%d", INT_2);
	printf("c: str2[0]= %c\n", str2[0]); // 2
	printf("d: str2[0]= %d\n", str2[0]); // 50
	printf("int: str2[0]= %d\n", (int)(*str2)); // 50
}

int main(void)
{
	string_process_function();
	
	return 0;
}
