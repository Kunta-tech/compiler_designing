%{
#include <stdio.h>
char buffer[100];
int comment_s = 0, comment_m = 0;
%}

%%
"//".*"\n"                { comment_s++; fputc('\n', yyout); }   // single line comment
"/*"([^*]|\*+[^/])*\*+"/" { comment_m++; }                        // multi  line comment
.|\n                      { fputc(yytext[0], yyout); }           // everything else
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
  printf("No. of single line comments: %d\n", comment_s);
  printf("No. of multi line comments: %d\n", comment_m);

  return 0;
}
int yywrap(){
  return 1;
}
