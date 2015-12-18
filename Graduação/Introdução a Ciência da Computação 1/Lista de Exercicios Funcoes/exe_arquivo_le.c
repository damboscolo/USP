#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

    FILE *Arquivo;
    int i, j, matriz[10][20];
    Arquivo = fopen("arquivo.txt", "r");
    if(Arquivo != NULL){
        for(i = 0; i < 10; i++){
            for(j = 0; j < 20; j++){
                fscanf(Arquivo, "%d ", &matriz[i][j]);
            }
        }
    }else{exit(0);}
    fclose(Arquivo);

    for(i = 0; i < 10; i++){
        for(j = 0; j < 20; j++){
            printf("%d ", matriz[i][j]);
        }
        printf("\n");
    }

    return 0;

}
