#include <stdlib.h>
#include <stdio.h>

int kesimopar(n);

int main(){

    int n;

    printf("Digite o k-esimo numero par a ser encontrado\n");
    scanf("%d", &n);
    printf("O %d numero par eh: %d", n, kesimopar(n));

    return 0;
}

int kesimopar(n){
    if(n == 0)
        return 0;
    else
        return 2 + kesimopar(n-1);
}
