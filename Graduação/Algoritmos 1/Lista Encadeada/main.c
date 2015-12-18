#include "lista_encadeada.h"

int main(){

    lista* l;
    bloco* a[100];
    elm v[100];
    int i, erro;
    l = (lista*) malloc(sizeof(lista));
    for(i = 0; i < 20; i++){
        v[i] = i*10;
    }
    push(l, &v[1], &erro);
    push(l, &v[2], &erro);
    push(l, &v[3], &erro);
    push(l, &v[4], &erro);
    push(l, &v[5], &erro);
    push(l, &v[6], &erro);
    push(l, &v[7], &erro);

    printlista(l);
    printf("inicio n = %d\n", l->inicio->n);
    shift(l);
    printf("inicio n = %d\n", l->inicio->n);
    printf("fim n = %d\n", l->fim->n);
    printf("inicio n = %d\n", l->inicio->n);
    pop(l);
    printf("fim n = %d", l->fim->n);

    return 0;

}
