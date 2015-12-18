#include "lista_encadeada.h"

void criaLista(lista* l){
    l->inicio = NULL;
    l->fim = NULL;
    l->criada = 1;
}

void finalizaLista(lista *l){
    bloco *b = l->inicio;
    while(b->b != NULL){
        l->inicio = l->inicio->b;
        free(b);
        b = l->inicio;
    };
}

bloco* criaBloco(elm x, int *erro){
    bloco* b = (bloco*) malloc(sizeof(bloco));
    if(b == NULL){
        *erro = 1;
        return b;
    }
    b->n = x;
    b->b = NULL;
    return b;
}

void push(lista* l, elm *x, int *erro){
    if(l->criada == 0)
        criaLista(l);
    bloco *b = criaBloco(*x, erro);
    if(*erro == 1)
        return;
    if(l->fim != NULL)
        l->fim
    if(l->inicio == NULL)
        l->inicio = b;
    l->fim = b;
    *erro = 0;
}

void insert(lista* l, elm *x, int *erro){
    if(l->criada == 0)
        criaLista(l);
    bloco* b = criaBloco(*x, erro);
    if(*erro == 1)
        return;
    if(l->inicio != NULL)
        b->b = l->inicio;
    if(l->fim == NULL)
        l->fim = b;
    l->inicio = b;
}

void pop(lista* l){
    if(l->criada == 0)
        return;
    bloco* b = l->inicio;
    while(b->b != l->fim)
        b = b->b;
    free(b->b);
    b->b = NULL;
    l->fim = b;
}

void shift(lista* l){
    if(l->criada == 0)
        return;
    bloco* ini = l->inicio;
    l->inicio = l->inicio->b;
    free(ini);
}

int size(lista* l){
    int i;
    bloco* b = l->inicio;
    while(b != NULL){
        b = b->b;
        i++;
    }
    return i;
}

int sizerec(lista l){
    if(l.inicio == NULL)
        return 0;
    else{
        l.inicio = l.inicio->b;
        return 1 + sizerec(l);
    }
}

int sizerec2(bloco* p){
    if(p == NULL)
        return 0;
    else
        return 1 + sizerec2(p->b);
}

int inlista(lista* l, elm* x){
    bloco* f = l->inicio;
    while(f != NULL){
        if(f->n == *x)
            return 1;
        f = f->b;
    }
    return 0;
}

int inlistarec(lista l, elm* x){
    if(l.inicio == NULL)
        return 0;
    else if(l.inicio->n == *x)
        return 1;
    else{
        l.inicio = l.inicio->b;
        return inlistarec(l, x);
    }
}

int inlistarec2(bloco* p, elm* x){
    if(p == NULL)
        return 0;
    else if(p->n == *x)
        return 1;
    else
        return inlistarec2(p->b, x);
}

void printlista(lista* l){
    bloco* f = l->inicio;
    while(f != NULL){
        printf("%d - ", f->n);
        f = f->b;
    }
    printf("\n");
}

void printlistarec(lista l){
    if(l.inicio == NULL){
        printf("\n");
        return;
    }
    printf("%d - ", l.inicio->n);
    l.inicio = l.inicio->b;
    printlistarec(l);
}
