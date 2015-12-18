#include "fila.h"

int main(){

    Fila a, b, c;
    cria(&a, inteiro);
    cria(&b, inteiro);
    cria(&c, inteiro);
    elm x, y;
    int erro, i, v1[4] = {0, 2, 4, 6}, v2[4] = {1, 3, 5, 7};

    for(i = 0; i < 4; i++){
        x = v1[i];
        y = v2[i];
        entra(&a, &x, &erro);
        entra(&b, &y, &erro);
    }

    unir(&a, &b, &c, &erro);

    for(i = 0; i < 8; i++){
        sai(&c, &x, &erro);
        printf("%d\n", x);
    }
}
