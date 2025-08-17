%{
#include <stdio.h>
#include <string.h>

int compound = 0;   // flag for compound sentence
%}

%%

(and|but|or|nor|for|yet|so)    { compound = 1; }   // Coordinating conjunctions

\n      { 
            if (compound) {
                printf("The given sentence is a COMPOUND sentence.\n");
            } else {
                printf("The given sentence is a SIMPLE sentence.\n");
            }
            compound = 0; // reset for next sentence
        }

.       ;   // ignore other characters

%%

int main() {
    printf("Enter a sentence (end with newline):\n");
    yylex();
    return 0;
}
