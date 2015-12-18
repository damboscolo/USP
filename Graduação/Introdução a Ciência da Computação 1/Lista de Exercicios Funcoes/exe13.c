#include <stdio.h>
#include <stdlib.h>

int soma(int n);

int main(){

    int n, res;

    printf("Digite o numero de numeros a serem somados\n");
    scanf("%d", &n);
    res = soma(n);
    printf("\nA soma de n numeros eh: %d", res);

    return 0;
}

int soma(int n){
    if(n == 0)
        return 0;
    else
        return n + soma(n-1);
}
