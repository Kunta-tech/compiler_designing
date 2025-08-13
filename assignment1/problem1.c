#include <stdio.h>
#include <ctype.h>

int isIdentifier(char* str){
	if(str==NULL) return 0;

	if(!isalpha(str[0]) && str[0]!='_') return 0;
	for(int i=1;i<100 && str[i]!='\0';i++)
		if(!isalnum(str[0]) && str[0]!='_') return 0;

	return 1;
}

int main(){
	char str[100];
	printf("Enter a string: ");
	scanf("%99s", str);

	if(isIdentifier(str))
		printf("It is a valid Identifier: %s\n", str);
	else
		printf("It is not a valid Identifier: %s\n", str);
	return 0;
}
