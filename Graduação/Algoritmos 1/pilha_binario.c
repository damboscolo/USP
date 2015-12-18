#include "pilha.h"
int main(){
    int n, i, bin, tam = 0, erro;
    Pilha* a;
    a = cria();
    printf("Digite um numero a ser convertido para binario\n");
    scanf("%d", &n);
    for(i = n; i > 0; i/=2){
        bin = i % 2;
        push(a, bin, &erro);
        tam++;
    }

    return;
}
