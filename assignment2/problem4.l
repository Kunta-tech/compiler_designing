%{
#include <stdio.h>
FILE *source, *target;
char buffer[100];

int comment_s = 0, comment_m = 0;
%}

%%
"//".*"\n"                { comment_s++; fputc('\n', target); }   // single line comment
"/*"([^*]|\*+[^/])*\*+"/" { comment_m++; }                        // multi  line comment
.                         { fputc(yytext[0], target); }           // all char except \n
\n                        { fputc('\n', target); }                // \n
%%

int main(){
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
  yylex();
  fclose(source);
  fclose(target);

  return 0;
}
int yywrap(){
  return 1;
}