#include <stdlib.h>
#include <stdio.h>

typedef int elm;

typedef struct bloco{
    elm n;
    struct bloco *b;
}bloco;

typedef struct{
    struct bloco *inicio, *fim;
    int criada;
}lista;

void criaLista(lista*);
void push(lista*, bloco*);
void insert(lista*, bloco*);
void pop(lista*);
void shift(lista*);

int main(){

    lista* l;
    bloco* a[100];
    int i;
    for(i = 0; i < 100; i++){
        a[i] = (struct bloco*) malloc(sizeof(struct bloco));
    }
    l = (lista*) malloc(sizeof(lista));
    a[1]->n = 10;
    a[2]->n = 20;
    a[3]->n = 30;
    a[4]->n = 40;
    push(l, a[1]);
    push(l, a[2]);
    push(l, a[3]);
    push(l, a[4]);
    printf("inicio n = %d\n", l->inicio->n);
    shift(l);
    printf("inicio n = %d\n", l->inicio->n);
    printf("fim n = %d\n", l->fim->n);
    pop(l);
    printf("fim n = %d", l->fim->n);
    return 0;

}

void criaLista(lista* l){
    l->inicio = NULL;
    l->fim = NULL;
    l->criada = 1;
}


void push(lista* l, bloco* b){
    if(l->criada == 0)
        criaLista(l);
    if(l->fim != NULL)
        l->fim->b = b;
    if(l->inicio == NULL)
        l->inicio = b;
    l->fim = b;
}

void insert(lista* l, bloco* b){
    if(l->criada == 0)
        criaLista(l);
    if(l->inicio != NULL)
        b->b = l->inicio;
    if(l->fim == NULL)
        l->fim = b;
    l->inicio = b;
}

void pop(lista* l){
    if(l->criada == 0)
        criaLista(l);
    bloco* b = l->inicio;
    while(b->b != l->fim)
        b = b->b;
    b->b = NULL;
    l->fim = b;
}

void shift(lista* l){
    if(l->criada == 0)
        criaLista(l);
    l->inicio = l->inicio->b;
}
