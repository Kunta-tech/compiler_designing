%{
#include <stdio.h>

int pos_int = 0, neg_int = 0;
int pos_frac = 0, neg_frac = 0;
%}

%%

[+]?[0-9]+\.[0-9]+   { pos_frac++; }   // +ve fraction (optional + sign)
-[0-9]+\.[0-9]+      { neg_frac++; }   // -ve fraction

[+]?[0-9]+           { pos_int++; }    // +ve integer (optional + sign)
-[0-9]+              { neg_int++; }    // -ve integer

[ \t\n]+             ;                 // ignore spaces, tabs, newlines
.                    ;                 // ignore other characters

%%

int main() {
    printf("Enter a string: ");
    yylex();

    printf("Positive Integers: %d\n", pos_int);
    printf("Negative Integers: %d\n", neg_int);
    printf("Positive Fractions: %d\n", pos_frac);
    printf("Negative Fractions: %d\n", neg_frac);

    return 0;
}

int yywrap() {
    return 1;
}
