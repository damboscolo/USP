#include <stdio.h>
#include <stdlib.h>

int primo(int m, int j);

int main(){

    int n;
    printf("Digite um numero\n");
    scanf("%d", &n);

    if(primo(n, 2) == 1)
        printf("O numero %d eh primo", n);
    else
        printf("O numero %d nao eh primo", n);

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
