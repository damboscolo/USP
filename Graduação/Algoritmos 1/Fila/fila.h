#include <stdlib.h>
#include <stdio.h>

#define TAM 100

typedef union{
    int i;
    float f;
}elm;

typedef struct{
    int inicio, fim, total;
    elm itens[TAM];
    enum tipo{
        inteiro, real
    }Tipo;
}Fila;

void cria(Fila* f, int* tipo){
    f->inicio = 0;
    f->fim = 0;
    f->total = 0;
    f->Tipo = *tipo;
}

void esvaziar(Fila *f){
    cria(f, inteiro);
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
        if(f->Tipo == inteiro)
            f->itens[f->fim].i = x->i;
        else
            f->itens[f->fim].f = x->f;
        f->total++;
        f->fim = f->fim<TAM-1?f->fim+1:0;
    }else
        *erro = 1;
}

void sai(Fila* f, elm* x, int* erro){
    if(!estaVazia(f)){
        *x = f->itens[f->inicio];
        f->total--;
        f->inicio = f->inicio<TAM-1?f->inicio+1:0;
    }else
        *erro = 1;
}

int crescente(Fila* f){
    int i;
    if(!estaVazia(f)){
        for(i = 0; i < f->fim -1; i++){
            if(f->itens[i] >= f->itens[i+1])
                return 0;
        }
        return 1;
    }
    return 0;
}

int inverter(Fila* a){
    Pilha* p;
    int erro;
    elm x;
    p = create();
    while(!estaVazia(a)){
        sai(a, &x, &erro);
        push(p, x, &erro);
    }
    while(!isEmpty(p, &erro)){
        x = pop(p, &erro);
        entra(a, &x, &erro);
    }
}

elm primeiro(Fila* f, int* erro){
    if(!estaVazia(f)){
        *erro = 0;
        return f->itens[f->inicio];
    }
    *erro = 1;
    return;
}

void unir(Fila* f1, Fila* f2, Fila* f3, int* erro){
    elm x,y;
    int total_f1, total_f2;
    if(f1->total+f2->total > TAM)
        *erro = 1;
    else{
        *erro = 0;
        total_f1 = f1->total;
        total_f2 = f2->total;
        while((total_f1>0) && (total_f2>0)){
            x = primeiro(f1, erro);
            y = primeiro(f2, erro);
            if(x<y){
                entra(f3, &x, erro);
                sai(f1, &x, erro);
                entra(f1, &x, erro);
                total_f1--;
            }else{
                entra(f3, &y, erro);
                sai(f2, &y, erro);
                entra(f2, &y, erro);
                total_f2--;
            }
        }
        while(total_f1>0){
            sai(f1, &x, erro);
            entra(f3, &x, erro);
            entra(f1, &x, erro);
            total_f1--;
        }
        while(total_f2>0){
            sai(f2, &y, erro);
            entra(f3, &y, erro);
            entra(f2, &y, erro);
            total_f2--;
        }
    }
}

void ler(elm *x, int* tipo){
    if(*tipo == 0)
        scanf("%d", &x->i);
    scanf("%f", &x->f);
}
