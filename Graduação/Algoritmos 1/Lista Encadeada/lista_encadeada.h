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
void finalizaLista(lista*);
bloco* criaBloco(elm, int*);
void push(lista*, elm*, int*);
void insert(lista*, elm*, int*);
void pop(lista*);
void shift(lista*);
int size(lista*);
int inlista(lista*, elm*);
int inlistarec(lista, elm*);
void printlista(lista*);
