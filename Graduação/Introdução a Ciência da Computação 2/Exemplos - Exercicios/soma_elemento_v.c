#include <stdio.h>
#include <stdlib.h>

int soma_valores(int*, int);

int main(){

    int v[10], i;
    for(i = 0; i < 10; i++){
        v[i] = i;
    }

    printf("A soma dos valores eh %d", soma_valores(v, 10));

    return 0;
}

int soma_valores(int* v, int tam){
    if(tam-1 <= 0)
        return v[tam-1];
    else{
        return v[tam-1] + soma_valores(v, tam-1);
    }
}
