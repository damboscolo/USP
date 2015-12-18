#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct{
    double x;
    int e;
}elm;

typedef struct{
    elm elementos[50];
    int tam;
}Polinomio;

double f(double po, Polinomio p, int deriva);

int main(){

    Polinomio *polinomio;
    polinomio = (Polinomio*) malloc(sizeof(Polinomio));
    int k, n = 0, i;
    double p = 0.0f, po = 0.0f, e = 0.0f, temp, fpoli, fpolideriva;
    //printf("Digite o numero de elementos no polinomio\n");
    scanf("%d", &n);
    polinomio->tam = n+1;
    for(i = 0; i < polinomio->tam; i++){
        scanf("%lf", &temp);
        polinomio->elementos[i].x = temp;
        polinomio->elementos[i].e = i;
    }
    //printf("\nDigite o ponto inicial\n");
    scanf("%lf", &po);
    //printf("Digite a precisao\n");
    scanf("%lf", &e);

    k = 1;
    while(k <= 10){
        fpoli = f(po, *polinomio, 0);
        fpolideriva = f(po, *polinomio, 1);
        if(fpolideriva==0){
            printf("erro");
            break;
        }
        p = po - (fpoli/fpolideriva);
        //printf("p = %f\np0 = %f\n", p, po);
        if(fabs(p - po) < e || (fabs(p-po)/fabs(p)) < e || fabs(f(p, *polinomio, 0)) < e){
                printf("%.4f", p);
                break;
        }/*else
            printf("If(%.6f < %.6f || %.6f < %.6f || %.6f < %.6f)\n", fabs(p - po), e, (fabs(p-po)/fabs(p)), e, fabs(f(p, *polinomio, 0)), e);
        */k++;
        po = p;
    }
    if(k > 10){
        printf("maximo de iteracoes\n");
        printf("%.4f", p);
    }

    return 0;

}

double f(double po, Polinomio poli, int deriva){
    int i;
    double soma = 0.0f;
    if(deriva){
        for(i = 0; i < poli.tam; i++){
            poli.elementos[i].x *= (double) poli.elementos[i].e;
            poli.elementos[i].e--;
        }
    }
    for(i = 0; i < poli.tam; i++){
        if(poli.elementos[i].e >= 0){
            soma += poli.elementos[i].x * pow(po, (double) poli.elementos[i].e);
            //printf("%.4f += %.4f * pow(%.4f, %.4f)\n", soma, poli.elementos[i].x, po, (double) poli.elementos[i].e);
        }
    }/*
    if(deriva)
        printf("polinomio derivado = %.8f\n", soma);
    else
        printf("polinomio = %.8f\n", soma);*/
    return soma;
}
