%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int char_count = 0;
int word_count = 0;
int keyword_count = 0;
int number_count = 0;
int space_count = 0;
int line_count = 0;

/* List of C keywords (can expand as needed) */
char *keywords[] = {
    "auto","break","case","char","const","continue","default","do","double",
    "else","enum","extern","float","for","goto","if","int","long",
    "register","return","short","signed","sizeof","static","struct","switch",
    "typedef","union","unsigned","void","volatile","while"
};
int num_keywords = 32;

int is_keyword(char *word) {
    for (int i = 0; i < num_keywords; i++) {
        if (strcmp(word, keywords[i]) == 0)
            return 1;
    }
    return 0;
}
%}

%%

[0-9]+                { number_count++; char_count += yyleng; }
[a-zA-Z_][a-zA-Z0-9_]* {
                         word_count++; 
                         if (is_keyword(yytext)) keyword_count++;
                         char_count += yyleng;
                       }
[ \t]+                { space_count += yyleng; char_count += yyleng; }
\n                    { line_count++; char_count++; }
.                     { char_count++; }

%%

int main() {
    FILE *file;
    char buffer[100];
    printf("Enter a c file: ");
    scanf("%s", buffer);
    file = fopen(buffer, "r");
    if(!file){
        printf("Could not open %s\n", buffer);
        return 1;
    }
    yyin = file;
    yylex();
    fclose(file);

    printf("Characters: %d\n", char_count);
    printf("Words: %d\n", word_count);
    printf("Keywords: %d\n", keyword_count);
    printf("Numbers: %d\n", number_count);
    printf("Spaces: %d\n", space_count);
    printf("End of lines: %d\n", line_count);

    return 0;
}

int yywrap() {
    return 1;
}
