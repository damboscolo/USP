#include <stdio.h>
#include <stdlib.h>

int contagem=0;

void permutacao(char v[], int tam, int itv);

int main(){
    char vetor[] = {'A', 'B', 'C', 'D', 'E'};
    permutacao(vetor, 5, 5);

    printf("\n\nNumero de permutacoes possiveis: %d\n",contagem);
}

void permutacao(char v[], int tam, int itv){
    int i;
    if(itv == 1){
        for(i = tam - 1; i >= 0; i--){
            printf("%c",v[i]);
        }
        printf("\n");
        contagem++;
    }else{
        char A;
        for(i = 0; i < itv; i++){
            A = v[i];
            v[i] = v[itv-1];
            v[itv-1] = A;

            permutacao(v, tam, itv-1);

            A = v[i];
            v[i] = v[itv-1];
            v[itv-1] = A;
        }
    }
}
