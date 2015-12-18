#include <stdio.h>
#include <stdlib.h>

int contadigitos(int n, int d);

int main(){

    int a, b, digitosa[9], digitosb[9], i, erro = 0;
    printf("Digite o primeiro numero\n");
    scanf("%d", &a);
    printf("Digite o segundo numero\n");
    scanf("%d", &b);

    for(i = 1; i < 10; i++){
        digitosa[i-1] = contadigitos(a, i);
        digitosb[i-1] = contadigitos(b, i);
    }

    for(i = 0; i < 9; i++){
        if(digitosa[i] != digitosb[i])
            erro++;
    }

    if(erro == 0)
        printf("%d eh permutacao de %d\n", a, b);
    else
        printf("%d nao eh permutacao de %d\n", a, b);

    return 0;
}

int contadigitos(int n, int d){
    if(n < 10)
        return n == d?1:0;
    else{
        if(n%10 == d)
            return 1 + (contadigitos(n/10, d));
        else
            return contadigitos(n/10, d);
    }
}
