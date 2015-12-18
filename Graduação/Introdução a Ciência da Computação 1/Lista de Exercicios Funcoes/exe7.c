#include <stdio.h>
#include <stdlib.h>

int primo(int m, int j);

int main(){

    int n, i = 1, soma = 0, nprimos = 0;

    printf("Digite o numero de primos a serem somados:\n");
    scanf("%d", &n);

    while(nprimos < n){
        if(primo(i, 2) == 1){
            soma += i;
            i++;
            nprimos++;
        }else
            i++;
    }

    printf("A soma dos %d primeiros primos eh %d", n, soma);

    return 0;
}

int primo(int m, int j){
    if(j > (m/2))
        return 1;
    else if((m % j) == 0)
        return 0;
    else
        return primo(m, (j+1));

}
