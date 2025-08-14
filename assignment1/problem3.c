#include <stdio.h>
#include <stdlib.h>

void removeComments(FILE *src, FILE *dest) {
    char ch, next;

    while ((ch = fgetc(src)) != EOF) {
        if (ch == '/') {
            next = fgetc(src);

            if (next == '/') {
                while ((ch = fgetc(src)) != EOF && ch != '\n');
                fputc('\n', dest);
            }
            else if (next == '*') {
                while ((ch = fgetc(src)) != EOF) {
                    if (ch == '*' && (next = fgetc(src)) == '/')
                        break;
                }
                fputc('\n', dest);
            }
            else {
                fputc(ch, dest);
                fputc(next, dest);
            }
        }
        else {
            fputc(ch, dest);
        }
    }
}

int main() {
    FILE *sourceFile, *targetFile;
    char sourceName[100], targetName[100];

    printf("Enter source file name: ");
    scanf("%s", sourceName);
    printf("Enter target file name: ");
    scanf("%s", targetName);

    sourceFile = fopen(sourceName, "r");
    if (!sourceFile) {
        printf("Error: Cannot open source file.\n");
        return 1;
    }

    targetFile = fopen(targetName, "w");
    if (!targetFile) {
        printf("Error: Cannot open target file.\n");
        fclose(sourceFile);
        return 1;
    }

    removeComments(sourceFile, targetFile);
    printf("Comments removed and saved to %s successfully.\n", targetName);
    fclose(sourceFile);
    fclose(targetFile);
    return 0;
}
