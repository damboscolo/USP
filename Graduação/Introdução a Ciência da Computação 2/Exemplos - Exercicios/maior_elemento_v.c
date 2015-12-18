#include <stdlib.h>
#include <stdio.h>

int maior_valor(int*, int, int);

int main(){

    int v[10], i;
    for(i = 0; i < 10; i++){
        v[i] = i;
    }


    printf("O maior valor eh %d", maior_valor(v, 10, 0));
}

int maior_valor(int* v, int tam, int maior){
    if(tam-1 <= 0)
        return maior;
    else{
        maior = v[tam-1]>maior?v[tam-1]:maior;
        return maior_valor(v, tam-1, maior);
    }
}
