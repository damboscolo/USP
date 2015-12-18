#include <stdlib.h>
#include <stdio.h>
typedef int elm;
typedef struct{
    int topo;
    elm itens[100];
}Pilha;

Pilha* create();
void push(Pilha*, elm, int*);
elm pop(Pilha*, int*);
elm top(Pilha*, int*);
void empty(Pilha*, int*);
int isEmpty(Pilha*, int*);
int isFull(Pilha*, int*);
void printPilha(Pilha, int*);
int compare(Pilha, Pilha, int*);
int reverse(Pilha *p, int*);

Pilha* create(){
    Pilha* p = (Pilha*) malloc(sizeof(Pilha));
    p->topo = -1;
    return p;
}

void push(Pilha* p, elm n, int* erro){
    if(isFull(p))
        *erro = 1;
    p->topo++;
    p->itens[p->topo] = n;
}

elm pop(Pilha* p, int* erro){
    elm n = p->itens[p->topo] ;
    p->topo--;
    return n;
}

elm top(Pilha* p, int* erro){
    if(!isEmpty(p)){
        *erro = 0;
        return p->itens[p->topo];
    }else{
        *erro = 1;
        return -1;
    }
}

void empty(Pilha* p, int *erro){
    p->topo = -1;
}

int isEmpty(Pilha* p, int *erro){
    if(p->topo >= 0)
        return 1;
    return 0;
}

int isFull(Pilha* p, int *erro){
    if(p->topo == 100)
        return 1;
    return 0;
}

void printPilha(Pilha p, int *erro){
    int i;
    elm x;
    int erro2 = 0;
    while(!isEmpty(&p, &erro2)){
        x = pop(&p, &erro2);
        printf("%d ", x);
    }
}

int compare(Pilha a, Pilha b, int *erro){
    int erroa, errob;
    if(a.topo == b.topo && !isEmpty(&a, erro)){
        while(!isEmpty(&a, erro)){
            if(pop(&a, &erroa) != pop(&b, &errob)){
                return -1;
            }
        }
        return 1;
    }
    return -1;
}

int reverse(Pilha *p, int *erro){
    int x;
    int erro, i = -1, j;
    elm v[p->topo];
    while(!isEmpty(p)){
        x = pop(p, &erro);
        i++;
        v[i] = x;
    }
    for(j = 0; j <= i; j++){
        push(p, v[j], &erro);
    }
}
