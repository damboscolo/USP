/*
* Eduardo Sigrist Ciciliato nº USP 7986542
* Gabriel Ribeiro nº USP 7986667
*/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void leDados(int, double**, double*);
void gauss(int, double**, double*, int*);
void subregressiva(int, double**, double*, double*);

double tol = 1.0e-10;

int main(){

    int n, i, erro = 0;
    double **A, *b, *x;
    scanf("%d", &n);
    A = (double**) malloc(sizeof(double*)*n);
    b = (double*) malloc(sizeof(double)*n);
    x = (double*) malloc(sizeof(double)*n);
    for(i = 0; i < n; i++){
        A[i] = (double*) malloc(sizeof(double)*n);
    }
    leDados(n, A, b);
    gauss(n, A, b, &erro);
    if(!erro){
        subregressiva(n, A, b, x);
        printf("\n");
        for(i = 0; i < n; i++){
            printf("%.4lf ", x[i]);
        }
    }
    printf("\n");
    return 0;
}


void leDados(int n, double **A, double *b){
    int i, j;
    double temp;
    for(i = 0; i < n; i++){
        for(j = 0; j < n; j++){
            scanf("%lf", &temp);
            A[i][j] = temp;
        }
    }
    for(i = 0; i < n; i++){
        scanf("%lf", &temp);
        b[i] = temp;
    }
}

void gauss(int n, double **A, double *b, int *erro){
    int i, j, k;
    double m;
    for(i = 0; i < n; i++){
        if(fabs(A[i][i]) < tol){
            printf("erro");
            *erro = 1;
            return;
        }
        for(j = i+1; j < n; j++){
            m = A[j][i] / A[i][i];
            for(k = 0; k < n; k++){
                A[j][k] -= (m * A[i][k]);
            }
            b[j] -= m * b[i];
        }
    }
    for(i = 0; i < n; i++){
        for(j = 0; j < n; j++){
            printf("%.4lf ", A[i][j]);
        }
        printf("\n");
    }
    for(i = 0; i < n; i++){
        printf("%.4lf ", b[i]);
    }
}

void subregressiva(int n, double **A, double *b, double *x){
    int i, j;
    double soma;
    if(fabs(A[n-1][n-1]) < tol){
        printf("erro");
        return;
    }
    x[n-1] = b[n-1] / A[n-1][n-1];
    for(i = n-2; i >= 0; i--){
        if(fabs(A[i][i]) < tol){
            printf("erro");
            return;
        }
        soma = 0.0f;
        for(j = i+1; j < n; j++){
            soma += A[i][j] * x[j];
        }
        x[i] = (b[i] - soma) / A[i][i];
    }
}
