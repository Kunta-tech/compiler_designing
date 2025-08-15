#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX 100
int stack[MAX];
int top = -1;

void push(int c) {
    stack[++top] = c;
}
int pop() {
    return stack[top--];
}
int peek() {
    return stack[top];
}
void look() {
    for(int i=0;i<=top;i++)
	printf("%d ",stack[i]);
    printf("\n");
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
            if(!fd) {
                fd = 1;
                postfix[k] = 0;
            }
            postfix[k] = postfix[k]*10 + (c-'0');
        }
        else if(fd) {
            fd = 0;
            k++;
        }
        if (isOperator(c)) {
            while (top != -1 && precedence(peek()) >= precedence(c)) {
                postfix[k++] = -pop();
            }
            push(c);
        }
	/* You can use this if you want to flex	
        else if (c == '(') {
            push(c);
        }
        else if (c == ')') {
            while (top != -1 && peek() != '(') {
                postfix[k++] = -pop();
            }
            pop();
        }
	*/
    }
    if(fd=1) k++;

    while (top != -1) {
        postfix[k++] = -pop();
    }
    postfix[k] = -('\n');
}
int eval(int postfix[]) {
    char ch;
    for(int i=0,j=0;i<MAX;i++){
	if(postfix[i]<0){
	    ch = (char)(-postfix[i]);
	    if(ch == '\n') break;
	    if(top>=1){
		int res=0;
		int b=pop(), a=pop();
		switch(ch){
		    case '+':
		        res=a+b;
			break;
		    case '-':
		        res=a-b;
			break;
		    case '*':
		        res=a*b;
			break;
		    case '/':
		        res=a/b;
			break;
		    default:
			printf("not an operation: %c\n",ch);
		}
		// printf("%c -> %d\n", ch, res);
	        push(res);
	    }
	}
	else{
	    push(postfix[i]);
	}
	// look();
    }
    return pop();
}

int main() {
    char infix[MAX];
    int postfix[MAX];

    printf("Enter infix expression: ");
    scanf("%s", infix);
    infixToPostfix(infix, postfix);
    printf("Result: %d\n", eval(postfix));

    return 0;
}
