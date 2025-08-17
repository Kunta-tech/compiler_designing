%{
#include <stdio.h>
char buffer[100];
int pf=0,sf=0;
%}

%%
"printf"  { fprintf(yyout, "writef");pf++; }
"scanf"   { fprintf(yyout, "readf");sf++;  }
.|\n	{ fputc(yytext[0], yyout); }
%%

int main(){
  FILE *source, *target;
  printf("Enter the source file: ");
  scanf("%s", buffer);
  source = fopen(buffer, "r");
  if(!source){
    printf("%s file can't be opened\n", buffer);
    return 1;
  }
  printf("Enter the target file: ");
  scanf("%s", buffer);
  target = fopen(buffer, "w");
  if(!target){
    printf("%s file can't be opened\n", buffer);
    fclose(source);
    return 1;
  }
  yyin = source;
  yyout = target;
  yylex();
  fclose(source);
  fclose(target);
  printf("No. of 'printf's: %d\n", pf);
  printf("No. of 'scanf's: %d\n", sf);

  return 0;
}
int yywrap(){
  return 1;
}
