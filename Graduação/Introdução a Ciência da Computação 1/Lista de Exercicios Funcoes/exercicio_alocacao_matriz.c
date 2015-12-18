#include <stdio.h>
#include <stdlib.h>

int** Alocar_matriz_real(int lin, int col);

int main(){

    int **matriz, linha, coluna, i, j, *m;
    printf("Digite o numero de linhas\n");
    scanf("%d", &linha);
    printf("Digite o numero de colunas\n");
    scanf("%d", &coluna);
    matriz = Alocar_matriz_real(linha, coluna);

    for(i = 0; i < linha; i++){
        m = matriz[i];
        for(j = 0; j < coluna; j++){
            printf("Linha %d / Coluna %d = %d\n", i, j, m[j]);
            free(m[j]);
        }
        free(matriz[i]);
    }
    free(matriz);
    return 0;

}

int** Alocar_matriz_real(int lin, int col){
    int **ponteiro;

    if(lin > 0 && col > 0){
        ponteiro = (int**) calloc(0, sizeof(int*));
        if(ponteiro == NULL)
            return NULL;
        else{
            for(i = 0; i < col; i++){
                ponteiro[i] = (int*) calloc(0, sizeof(float));
                if(ponteiro[i]==NULL)
                    return NULL;
            }
            return ponteiro;

        }
    }else
        return NULL;

}
