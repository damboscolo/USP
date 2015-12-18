/*
*
*   Daniele Hidalgo Boscolo     7986625
*   Hiero Martinelli            7986646
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double f(double equacao[], double ponto, int n){
    int i;
    double resp = 0;
    for(i=0;i<=n;i++){
        resp += pow(ponto,(double)i) * equacao[i];
    }
    return resp;
}

#define NPONTOS 4

int main(){
    int n, i, j;
    double F[NPONTOS][NPONTOS], x[NPONTOS], p;

    scanf("%d", &n);

    double equacao[n];

    for(i = 0; i < n; i++){
        for(j = 0; j < n; j++){
            F[i][j] = 0.0f;
        }
    }

    for(i = 0; i <= n; i++){
        scanf("%lf", &equacao[i]);
    }
    scanf("%lf",&p);

    //GERA PONTOS
    x[0] = p - 2;
    x[1] = p - 1;
    x[2] = p + 1;
    x[3] = p + 2;

    //CALCULO DA FUNCAO NO F[x1]
    for(i = 0; i < NPONTOS; i++){
        F[i][0] = f(equacao, x[i], n);
    }

    for(i = 1; i < NPONTOS; i++){
        for(j = 1; j <= i; j++){
            F[i][j] = ((F[i][j - 1] - F[i-1][j-1]) / (x[i] - x[i-j]));
        }
    }
    for(i = 0; i < NPONTOS; i++){
        printf("%.4lf ",x[i]);
        for(j = 0; j <= i; j++){
            printf("%.4lf ",F[i][j]);
        }
        printf("\n");
    }

    printf("P1(x) = %.4lf + (%.4lf)(x-(%.4lf))",F[1][0],F[2][1],x[1]);
    printf("\nP2(x) = %.4lf + (%.4lf)(x-(%.4lf)) + (%.4lf)(x-(%.4lf))(x-(%.4lf))",F[0][0],F[1][1],x[0],F[2][2],x[0],x[1]);
    printf("\nP3(x) = %.4lf + (%.4lf)(x-(%.4lf)) + (%.4lf)(x-(%.4lf))(x-(%.4lf))",F[1][0],F[2][1],x[1],F[3][2],x[1],x[2]);
    printf("\nP4(x) = %.4lf + (%.4lf)(x-(%.4lf)) + (%.4lf)(x-(%.4lf))(x-(%.4lf)) + ((%.4lf))(x-(%.4lf))(x-(%.4lf))(x-(%.4lf))\n",F[0][0],F[1][1],x[0],F[2][2],x[0],x[1], F[3][3], x[0],x[1],x[2]);

    double result[5];
    result[0] = f(equacao,p,n);
    result[1] = F[1][0] + ((F[2][1])*(p-(x[1])));
    result[2] = F[0][0] + ((F[1][1])*(p-(x[0]))) + ((F[2][2])*(p-(x[0]))*(p-(x[1])));
    result[3] = F[1][0] + ((F[2][1])*(p-(x[1]))) + ((F[3][2])*(p-(x[1]))*(p-(x[2])));
    result[4] = F[0][0] + ((F[1][1])*(p-(x[0]))) + ((F[2][2])*(p-(x[0]))*(p-(x[1]))) + ((F[3][3])*(p-(x[0]))*(p-(x[1]))*(p-(x[2])));

    /*
    for(i=0;i<5;i++){
        printf("%.4lf ",result[i]);
    }
    */
    printf("%.4lf %.4lf %.4lf %.4lf %.4lf\n", result[0], result[1], result[2], result[3], result[4]);
    return 0;
}
