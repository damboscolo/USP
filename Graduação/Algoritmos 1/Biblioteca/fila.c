#include "fila.h"

void cria(Fila* f){
    f->inicio = 0;
    f->fim = 0;
    f->total = 0;
}

void esvaziar(Fila *f){
    cria(f);
}

int estaVazia(Fila* f){
    if(f->total > 0)
        return 0;
    return 1;
}

int estaCheia(Fila* f){
    if(f->total == TAM)
        return 1;
    return 0;
}

void entra(Fila* f, elm* x, int* erro){
    if(!estaCheia(f)){
        f->pessoas[f->fim] = *x;//vai pro fim da fila
        f->total++;
        f->fim = f->fim<TAM-1?f->fim+1:0;
    }else
        *erro = 1;
}

void sai(Fila* f, elm* x, int* erro){
    if(!estaVazia(f)){
        *x = f->pessoas[f->inicio];
        f->total--;
        f->inicio = f->inicio<TAM-1?f->inicio+1:0;
    }else
        *erro = 1;
}


elm primeiro(Fila* f, int* erro){
    if(!estaVazia(f)){
        *erro = 0;
        return f->pessoas[f->inicio];
    }
    *erro = 1;
    return;
}


