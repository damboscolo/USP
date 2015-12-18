#include <stdio.h>
#include <stdlib.h>

int busca_seq(int*, int, int);

int main(){

    int v[10], i, x;
    for(i = 0; i < 10; i++)
        v[i] = i;

    x = busca_seq(v, 9, 5);
    if(x >= 0)
        printf("O numero foi encontrado na posicao %d", x);
    else
        printf("O numero nao foi encontrado");
    return 0;
}

int busca_seq(int* v, int tam, int busca){
    if(tam <= -1)
        return -1;
    else{
        if(v[tam] == busca)
            return tam;
        else
            return busca_seq(v, tam-1, busca);
    }
}
