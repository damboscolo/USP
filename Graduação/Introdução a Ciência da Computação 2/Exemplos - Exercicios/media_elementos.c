#include <stdlib.h>
#include <stdio.h>

int media_valores(int*, int, int);

int main(){

    int v[10], i;
    for(i = 0; i < 10; i++){
        v[i] = 2;
    }

    printf("A media dos valores eh %d", soma_valores(v, 10, 0));

    return 0;
}

int media_valores(int* v, int tam, int soma){
    if(tam-1 <= 0)
        return v[tam-1];
    else{
        return soma_valores(v, tam-1, v[tam-1]);
    }
}
