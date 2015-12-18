#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>

typedef int elm;

typedef struct{
    float rf,gf,bf;
    int ri,gi,bi;
}Cor;

typedef struct{
    int id[100];
    Cor *c[100];
    int topo;
}lista_cores;

typedef struct{
    elm valor;
    int ativo, estado;
    float x, y, width, height, margin[4], movendo;
    Cor c;
}elemento;

typedef struct{
    int xi, yi;
    float xf, yf;
}point;

typedef struct{
    int xi, yi, widthi, heighti;
    float xf, yf, widthf, heightf;
}area;

enum pos{POS_X, POS_Y, POS_BOTH};
enum margin{MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM};

void Escreve(char*, Cor, float, float, int);
void criaCori(Cor*, int, int, int);
void criaCorf(Cor*, float, float, float);
int* getCoresi(Cor*);
float* getCoresf(Cor*);
void criaListaCores(lista_cores*);
void lista_cores_adiciona_cor(lista_cores*, Cor*);
void setPointi(point*, int, int);
void setPointf(point*, float, float);
int* getPointi(point*);
float* getPointf(point*);
void setAreai(area*, int, int, int, int);
void setAreaf(area*, float, float, float, float);
int* getAreai(area*);
float* getAreaf(area*);
void anima_elemento(int, point, int, elemento*);
void square(area*);
void legenda(char**, lista_cores*, point);
