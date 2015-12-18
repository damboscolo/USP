#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

    FILE *Arquivo;
    int i, j, alea;
    srand ( time(NULL) );
    Arquivo = fopen("arquivo.txt", "w");
    for(i = 0; i < 10; i++){
        for(j = 0; j < 20; j++){
            alea = rand()%100;
            fprintf(Arquivo, "%d ", alea);
        }
        fprintf(Arquivo, "\n");
    }
    fclose(Arquivo);

    return 0;

}
