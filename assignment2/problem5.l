%{
#include <stdio.h>
char buffer[100];
%}

%%
"printf"  { fprintf(yyout, "writef"); }
"scanf"   { fprintf(yyout, "readf");  }
.|\n                      { fputc(yytext[0], target); }           // everything else
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

  return 0;
}
int yywrap(){
  return 1;
}