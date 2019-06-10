#include <stdio.h>
#include <string.h>

#define M_SUCCESS (0)
#define M_FAIL (1)

#define F_TYPE_COMMON ("-com")
#define F_TYPE_PUBLIC ("-pub")
#define F_TYPE_PRIVATE ("-pri")

typedef struct {
     unsigned int bits; // length in bits of modulus
     unsigned int modulus; // modulus 【e】
     unsigned char exponent[256]; // public exponent 【n】
 
} RSA_PUBLIC_KEY;
 
//RSA私钥格式(兼容1024,2048)
 typedef struct {
     unsigned int bits; // length in bits of modulus
     unsigned int modulus; // modulus 【e】
     unsigned char publicExponent[256]; // public exponent 【n】
     unsigned char exponent[256]; // private exponent 【d】
 
} RSA_PRIVATE_KEY;

 void pause()
 {
	 getchar();
 }

 void usage()
 {
 }

 void input()
 {

 }

 void output(int count, FILE* fp_out, char* str, unsigned char* data)
 {
	char* brace = NULL;
	int i;
	// 结构体形式
	brace = "{";
	printf("%s", brace);
	fwrite(brace, 1, strlen(brace), fp_out);
	for (i = 0; i < count; i++)
	{
		memset(str, 0, sizeof(str));
		sprintf(str, " 0x%02X,", data[i]);
		printf("%s", str);
		fwrite(str, 1, strlen(str), fp_out);
		if ((i + 1) % 16 == 0)
		{
			printf("\n");
			fwrite("\n", 1, strlen(str), fp_out);
		}
	}
	brace = "}";
	printf("%s\n", brace);
	fwrite(brace, 1, strlen(brace), fp_out);

	// 16进制形式
	printf("\n");
	fwrite("\n", 1, strlen(str), fp_out);
	for (i = 0; i < count; i++)
	{
		memset(str, 0, sizeof(str));
		sprintf(str, " 0x%02X", data[i]);
		printf("%s", str);
		fwrite(str, 1, strlen(str), fp_out);
		if ((i + 1) % 16 == 0)
		{
			printf("\n");
			fwrite("\n", 1, strlen(str), fp_out);
		}
	}
	printf("\n", brace);

	// 10进制形式
	printf("\n");
	fwrite("\n", 1, strlen(str), fp_out);
	for (i = 0; i < count; i++)
	{
		memset(str, 0, sizeof(str));
		sprintf(str, " %d", data[i]);
		printf("%s", str);
		fwrite(str, 1, strlen(str), fp_out);
		if ((i + 1) % 16 == 0)
		{
			printf("\n");
			fwrite("\n", 1, strlen(str), fp_out);
		}
	}
	printf("\n", brace);
 }

int main(int argc, char* argv[])
{
	char* f_type = NULL;
	char* f_path = NULL;
	char f_out[512] = {0};
	char* brace = NULL;
	unsigned char data[2048] = {0};
	char str[32] = {0};
	int count = 0;
	int i;

	FILE* fp_in = NULL;
	FILE* fp_out = NULL;
	
	int s_size = 0;// structure size

	if (argc < 3) 
	{
		printf("Error: Arguments count is not enough! \n");
		pause();
		return M_FAIL;
	}

	f_type = argv[1];
	f_path = argv[2];

	fp_in = fopen(f_path, "rb");
	if (fp_in == NULL)
	{
		printf("Error: Open file<%s> error! \n", f_path);
		return M_FAIL;
	}

	if (!memcmp(f_type, F_TYPE_PUBLIC, strlen(F_TYPE_PUBLIC) + 1))
	{
		printf("Debug: f_type= %s\n", f_type);

		s_size = sizeof(RSA_PUBLIC_KEY);
		count = fread(data, 1, s_size, fp_in);

		printf("Debug: s_size= %d\n", s_size);
		if (count != s_size)
		{
			printf("Error: count<%d> != s_size<%d> \n", count, s_size);
			return M_FAIL;
		}

		/*
		 *print every byte in Hex String
		 *write to file
		 */
		sprintf(f_out, "%s_out", f_path);
		fp_out = fopen(f_out, "w");
		if (fp_out == NULL)
		{
			printf("Error: Open file<%s> error! \n", f_path);
			return M_FAIL;
		}

		output(count, fp_out, str, data);
	}
	else if (!memcmp(f_type, F_TYPE_PRIVATE, strlen(F_TYPE_PUBLIC) + 1))
	{
		printf("Debug: f_type= %s\n", f_type);

		s_size = sizeof(RSA_PRIVATE_KEY);
		count = fread(data, 1, s_size, fp_in);

		printf("Debug: s_size= %d\n", s_size);
		if (count != s_size)
		{
			printf("Error: count<%d> != s_size<%d> \n", count, s_size);
			return M_FAIL;
		}

		/*
		 *print every byte in Hex String
		 *write to file
		 */
		sprintf(f_out, "%s_out", f_path);
		fp_out = fopen(f_out, "w");
		if (fp_out == NULL)
		{
			printf("Error: Open file<%s> error! \n", f_path);
			return M_FAIL;
		}

		output(count, fp_out, str, data);
	}
	else if (!memcmp(f_type, F_TYPE_COMMON, strlen(F_TYPE_COMMON) + 1))
	{
		int index = 0;
		count = fread(data, 1, 2048, fp_in);
		if (count <= 0)
		{
			printf("Error: count <= 0 error! \n", f_path);
			return M_FAIL;
		}

		/*
		 *print every byte in Hex String
		 *write to file
		 */
		sprintf(f_out, "%s_out", f_path);
		fp_out = fopen(f_out, "w");
		if (fp_out == NULL)
		{
			printf("Error: Open file<%s> error! \n", f_path);
			return M_FAIL;
		}

		output(count, fp_out, str, data);
	}
	else
	{
		printf("Error: Illegal file type<%s> error! \n", f_type);
		return M_FAIL;
	}

	if (fp_in != NULL)
	{
		fclose(fp_in);
	}
	if (fp_out != NULL)
	{
		fflush(fp_out);
		fclose(fp_out);
	}

	pause();
	return M_SUCCESS;
}

/*
		// print every byte in Hex String
		printf("{");
		for (i = 0; i < count; i++)
		{
			printf(" 0x%02X,", data[i]);
		}
		printf("}\n");

		printf("{");
		for (i = 0; i < count; i++)
		{
			memset(str, 0, sizeof(str));
			sprintf(str, " 0x%02X,", data[i]);
			printf("%s", str);
		}
		printf("}\n");
*/