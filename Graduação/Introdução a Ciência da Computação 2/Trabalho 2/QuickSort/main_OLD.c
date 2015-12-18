#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

void quickSort(int[], int, int);
void desenha();
void update(int[]);
char desenho[10][10];

int main(){

    int v[10] = { 3, 5, 9, 1, 2, 6, 8, 4, 0, 7 }, i, j;
    for(i = 0; i < 10; i++){
        for(j = 0; j < 10; j++){
            desenho[i][j] = ' ';
        }
    }
    quickSort(v, 0, 9);
        update(v);
        desenha();
    return 0;
}

void troca(int *a, int *b){
    int aux;
    aux = *a;
    *a = *b;
    *b = aux;
}

int particiona(int v[], int esq, int dir){
    int a, cima, baixo, i;

    a = v[esq];
    cima = dir;
    baixo = esq;
    while(baixo < cima){ // Enquanto o de baixo for menor q o de cima continua trocando
        while(v[baixo] <= a && baixo < dir) // se o v na posicao baixo for menor q o valor escolhido e o baixo estiver menor q o final baixo eh incrementado
            baixo++;
        while(v[cima] > a)// se v cima for maior que a pega o proximo alto
            cima--;
        if(baixo < cima) // Se o baixo for menor q o cima troca a posicao dos seus valores
            troca(&v[baixo], &v[cima]);
        Sleep(1000);
        update(v);
        desenha();
    }
    v[esq] = v[cima]; //Troca o valor inicial com o valor final do de cima
    v[cima] = a; // O valor do de cima eh o valor inicial
    return cima;
}

void quickSort(int v[], int esq, int dir) {
  int r;

  if (dir > esq) {
    r = particiona(v, esq, dir); // Particiona o vetor e ordena
    quickSort(v, esq, r - 1); // Pega a parte esquerda e aplica a mesma funcao
    quickSort(v, r + 1, dir); // Pega a parte direita e aplica a mesma funcao
  }
}

void desenha(){
    system("cls");
    int i, j;
    for(i = 0; i < 10; i++){
        for(j = 0; j < 10; j++){
            printf("%c ", desenho[i][j]);
        }
        printf("\n");
    }
}

void update(int v[]){
    int i, j;
    for(i = 0; i < 10; i++){
        for(j = 0; j < 10; j++){
            if(10 - i - v[j] <= 0)
                desenho[i][j] = 'H';
            else
                desenho[i][j] = ' ';
        }
    }
}
