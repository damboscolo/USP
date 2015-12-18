#include "Inversao.h"

void troca(int valores[], int x, int y) {
    int aux = valores[x];
    valores[x] = valores[y];
    valores[y] = aux;
    return 0;
}

void inversao(int valores[], int n) {
    int i;
    for(i = 0; i < n/2; i++){
        troca(valores, i, n-i-1);
    }
    return 0;
}
