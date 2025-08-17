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
    printf("Vowels: %d\n", vowel_count);
    printf("Consonants: %d\n", consonant_count);
    return 0;
}
int yywrap() {
    return 1;
}
