%{
#include <stdio.h>
int vow = 0, con = 0;
%}
%%
[aeiouAEIOU]      { vow++; }
[a-zA-Z]          { con++; }
.|\n              {}
%%
int main() {
    printf("Enter a string: ");
    yylex();
    printf("No. of Vowels: %d\n", vow);
    printf("No. of Consonants: %d\n", con);
    return 0;
}
int yywrap() {
    return 1;
}
