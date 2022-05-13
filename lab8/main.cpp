#include <iostream>

#define MAXLEN 100

extern "C"
{
	void strncpyAsm(char* dst, char* src, int size); // Функция strncpy на ассемблере
}

int strlenAsm(const char* mystr)
{
	int len = 0;

	__asm 
	{
		xor ECX, ECX 
		mov ECX, MAXLEN
		mov EDI, mystr
		xor AL, AL
		repne scasb // Найти байт равный AL в блоке из (E)CX байт по адресу ES:(E)DI

		mov EAX, MAXLEN
		sub EAX, ECX
		dec EAX
		mov len, EAX
	}

	return len;
}

int main()
{
	std::cout << strlenAsm("1234") << std::endl;

	char a[MAXLEN] = "123456";
	char *b = a + 2;

	strncpyAsm(b, a, 3);
	std::cout << b;

	return 0;
}