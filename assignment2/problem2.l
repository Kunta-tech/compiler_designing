%{
#include <stdio.h>

int vowel_count = 0;
int consonant_count = 0;
%}

%%

[aeiouAEIOU]      { vowel_count++; }
[a-zA-Z]          { consonant_count++; }
.|\n              { /* ignore anything else */ }

%%

int main() {
    printf("Enter a string: ");
    yylex();   // process input

    printf("Vowels: %d\n", vowel_count);
    printf("Consonants: %d\n", consonant_count);

    return 0;
}

int yywrap() {
    return 1;
}
