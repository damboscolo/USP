#include <stdio.h>
#include <stdlib.h>

typedef struct{
    int n;
    struct A *a;
}A;



int main(){

    int n, i;
    A a;

    printf("Digite um numero\n");
    scanf("%d", &n);
    for(i = 0; i < n; i++){
        a.n = 0;
        a.a = &a;
    }
    for(i = 0; i < n; i++){
        printf("%d\n", a.n);
        a.a = &a;
        a.n++;
    }

    return 0;

}
