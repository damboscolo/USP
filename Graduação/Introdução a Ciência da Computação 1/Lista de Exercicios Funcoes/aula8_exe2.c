#include <stdio.h>
#include <stdlib.h>

int main(){

    int n, **matriz, i, j;

    printf("Digite o numero maximo da tabuada\n");
    scanf("%d", &n);

    matriz = (int **) malloc(sizeof(int) * n);

    for(i = 1; i < n+1; i++){
        matriz[i] = (int *) malloc(sizeof(int) * 9);
        for(j = 1; j < 10; j++){
            matriz[i][j] = i*j;
        }
    }

    for(i = 1; i < n+1; i++){
        for(j = 1; j < 10; j++){
            printf("%dx%d = %d ", i, j, matriz[i][j]);
        }
        printf("\n");
    }

    return 0;

}
