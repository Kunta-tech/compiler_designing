#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX 100
char stack[MAX];
int top = -1;

void push(char c) {
    stack[++top] = c;
}
char pop() {
    return stack[top--];
}
char peek() {
    return stack[top];
}

int precedence(char op) {
    switch (op) {
        case '*':
        case '/': return 2;
        case '+':
        case '-': return 1;
        default: return 0;
    }
}
int isOperator(char c) {
    return (c == '+' || c == '-' || c == '*' || c == '/' || c == '^');
}

void infixToPostfix(char infix[], int postfix[]) {
    int i, k = 0, fd=0;
    char c;

    for (i = 0; infix[i] != '\0'; i++) {
        c = infix[i];
        if (isdigit(c)) {
            if(fd==0) {
                fd = 1;
                postfix[k] = 0;
            }
            postfix[k] = postfix[k]*10 + c;
        }
        else {
            fd = 0;
            k++;
        }
        if (c == '(') {
            push(c);
        }
        else if (c == ')') {
            while (top != -1 && peek() != '(') {
                postfix[k++] = -pop();
            }
            pop();
        }
        else if (isOperator(c)) {
            while (top != -1 && precedence(peek()) >= precedence(c)) {
                postfix[k++] = -pop();
            }
            push(c);
        }
    }

    while (top != -1) {
        postfix[k++] = -pop();
    }
    postfix[k] = -('\0');
}
int eval(int postfix[]) {
    int res = 0;
    char ch;
    for(int i=0;i<MAX;i++){
        printf((postfix[i]>=0)?"%d ":"%c ",(postfix[i]>=0)?postfix[i]:(char)(-postfix[i]));
    }
    printf("\n");
    return res;
}

int main() {
    char infix[MAX];
    int postfix[MAX];

    printf("Enter infix expression: ");
    scanf("%s", infix);
    infixToPostfix(infix, postfix);
    printf("Postfix expression: %s\n", postfix);

    return 0;
}
