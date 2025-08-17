%{
#include <stdio.h>
#include<string.h>
int isExpr = 1, isOpt=-1;
char iden[20][20], ops[20];
int idenT=-1,opsT=-1;
int isIdentifier(char* str){
	if(str==NULL) return 0;

	if(!isalpha(str[0]) && str[0]!='_') return 0;
	for(int i=1;i<100 && str[i]!='\0';i++)
		if(!isalnum(str[0]) && str[0]!='_') return 0;

	return 1;
}
%}

%%
[a-zA-Z0-9]+    { 
                  if(isExpr && isOpt!=0) isOpt=0; else if(isOpt==0) isExpr=0;
                  if(isIdentifier(yytext)) {strcpy(iden[++idenT],yytext);} 
                }
[+-*/]          {
                  if(isExpr && isOpt!=1) isOpt=1; else if(isOpt==1) isExpr=0;
                  ops[++opsT]=yytext[0];
                }
.|\n {}
%%

int main{
  yylex();
  if(isExpr){
    printf("Valid Expression\n");
  }else{
    printf("Invalid Expression\n");
  }
  printf("Identifiers found:\n");
  for(int i=0;i<=idenT;i++){
    printf("%s%s", iden[i], (i==idenT?", ":"\n"));
  }
  printf("Operators found:\n");
  for(int i=0;i<=opsT;i++){
    printf("%c%c", ops[i], (i==opsT?", ":"\n"));
  }
  return 0;
}
int yywrap() { return 1; }