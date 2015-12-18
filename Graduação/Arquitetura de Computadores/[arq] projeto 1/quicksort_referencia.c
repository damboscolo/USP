#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#define TAM 50

void quickSort(int[], int, int);
int particiona(int[], int, int);
void troca(int*, int*);

int main(){

    srand ( time(NULL) );
    int valores[TAM], arrumado;
    int i;


    for(i = 0; i < TAM; i++){
        valores[i] = rand() % 220;
		printf("%d, ", valores[i]);
    }

	quickSort(valores, 0, TAM-1);
	printf("\n");
	for(i = 0; i < TAM; i++){
		printf("%d, ", valores[i]);
	}

    return 0;
}

void troca(int *a, int *b){
    int aux;
    aux = *a;
    *a = *b;
    *b = aux;
}

int particiona(int v[], int esq, int dir){
    int a, cima, baixo;

    a = v[esq];
    cima = dir;
    baixo = esq;
    while(baixo < cima){ // Enquanto o de baixo for menor q o de cima continua trocando
        while(v[baixo] >= a && baixo < dir){ // se o v na posicao baixo for menor q o valor escolhido e o baixo estiver menor q o final baixo eh incrementado
            baixo++;
        }
        while(v[cima] < a){// se v cima for maior que a pega o proximo alto
            cima--;
        }
        if(baixo < cima){ // Se o baixo for menor q o cima troca a posicao dos seus valores
            troca(&v[baixo], &v[cima]);
        }
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
