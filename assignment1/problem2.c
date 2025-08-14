#include <stdio.h>
#include <string.h>
#include <ctype.h>

int isValidComment(char *str) {
    int len = strlen(str);
    while (isspace(*str)) str++;

    if (strncmp(str, "//", 2) == 0) {
        return 1;
    }

    if (strncmp(str, "/*", 2) == 0 && len >= 4) {
        while (len > 0 && isspace(str[len - 1])) len--;
        if (str[len - 2] == '*' && str[len - 1] == '/')
            return 1;
    }

    return 0;
}

int main() {
    char line[200];
    printf("Enter a C statement: ");
    fgets(line, sizeof(line), stdin);

    size_t l = strlen(line);
    if (l > 0 && line[l - 1] == '\n') line[l - 1] = '\0';

    if (isValidComment(line))
        printf("Valid Comment\n");
    else
        printf("Not a Valid Comment\n");

    return 0;
}
