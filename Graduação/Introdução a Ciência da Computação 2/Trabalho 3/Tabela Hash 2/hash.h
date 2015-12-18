#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include "visual.h"

#define HTAM 13

typedef char hashinfo;
enum setatype{DOWN_RIGHT, RIGHT_DOWN_LEFT, RIGHT_UP_LEFT};

typedef struct{
    hashinfo *nome;
    int prox;
}musica;

typedef struct{
    musica *musicas[30], *temp[30];
    int m, vazio;
}tabelahash;

typedef struct{
    int indice, m;
    Cor mcores[30], pcores[30];
}hash;

typedef struct{
    char *x;
    point *coord;
}escrita;

typedef struct{
    area *a;
    Cor *cor;
}box;

typedef struct{
    int tipo, *tamanhos;
    Cor *cor;
    point *inicio, *fim;
}seta;

typedef struct{
    seta **setas;
    box **boxes;
    escrita **escritas;
    point *underscore;
    int topo_s, topo_b, topo_e;
}tela;

void escrita_cria(escrita**, char*, int, int);
void box_cria(box**, int, int, int, int, float, float, float);
void seta_cria(seta**, int, int, int, int, int, int*, float, float, float);
void tela_add_escrita(tela**, escrita*);
void tela_add_box(tela**, box*);
void tela_add_seta(tela**, seta*);
void tela_remove_musica(tela**, hashinfo*);
void DesenhaBox(box*);
void DesenhaEscrita(escrita*);
void DesenhaSeta(seta*);
void DesenhaUnderscore(point*);
void Delay(int, void (*f)());
int hash_hashinterno(char*);
void hash_insere(tabelahash**, hashinfo**, int*, void (*f)());
int hash_remove(tabelahash**, hashinfo**, int*, void (*f)());
int hash_busca(tabelahash**, hashinfo**, int*, void (*f)());
