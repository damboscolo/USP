#include <stdlib.h>
#include <stdio.h>

#define TAM 100

typedef struct{
    char nome[100], email[100];
}elm;

typedef struct{
    int inicio, fim, total;
    elm pessoas[TAM];
}Fila;

void cria(Fila* f);
void esvaziar(Fila *f);
int estaVazia(Fila* f);
int estaCheia(Fila* f);
void entra(Fila* f, elm* x, int* erro);
void sai(Fila* f, elm* x, int* erro);
elm primeiro(Fila* f, int* erro);
