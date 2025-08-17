/* Lex program to Count the Positive numbers, - Negative numbers and Fractions  */

%{
#include<stdio.h>
int posint=0, negint=0,posfraction=0, negfraction=0;
%}

%%
[-][0-9]+ {negint++, yytext;}
[+]?[0-9]+ {posint++, yytext;}
[+]?[0-9]*\.[0-9]+ {posfraction++, yytext;}
[-][0-9]*\.[0-9]+ {negfraction++, yytext;}
.;
%%

int main() 
{ 
    printf("Enter Positive numbers, Negative numbers and Fractions\n");
    yylex(); 
    printf("\nNo. of positive numbers: %d", posint); 
    printf("\nNo. of Negative numbers: %d", negint); 
    printf("\nNo. of Positive numbers in fractions: %d", posfraction); 
    printf("\nNo. of Negative numbers in fractions: %d\n", negfraction); 
    return 0; 
} 

int yywrap()
{
return 1;
}