%{
#include <stdio.h>
#include <stdlib.h>

int result = 0;      // Final result
int num = 0;         // Temporary number
char op = '+';       // Current operator (default +)
%}

%%

[0-9]+      {
                num = atoi(yytext);   // convert token to integer

                switch(op) {
                    case '+': result += num; break;
                    case '-': result -= num; break;
                    case '*': result *= num; break;
                    case '/': 
                        if(num != 0) result /= num; 
                        else {
                            printf("Error: Division by zero!\n");
                            exit(1);
                        }
                        break;
                }
            }

[+\-*/]     { op = yytext[0]; }   // store operator

\n          { 
                printf("Result = %d\n", result);
                result = 0;  // reset for next expression
                op = '+'; 
            }

[ \t]       ;   // ignore spaces and tabs
.           { printf("Invalid character: %s\n", yytext); }

%%

int main() {
    printf("Enter arithmetic expression (end with newline):\n");
    yylex();
    return 0;
}
