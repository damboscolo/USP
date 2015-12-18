#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[]){

    char meses[13][30];
    int dia, mes, ano;

    strcpy(meses[1], "Janeiro");
    strcpy(meses[2], "Fevereiro");
    strcpy(meses[3], "Março");
    strcpy(meses[4], "Abril");
    strcpy(meses[5], "Maio");
    strcpy(meses[6], "Junho");
    strcpy(meses[7], "Julho");
    strcpy(meses[8], "Agosto");
    strcpy(meses[9], "Setembro");
    strcpy(meses[10], "Outubro");
    strcpy(meses[11], "Novembro");
    strcpy(meses[12], "Dezembro");

    if(argc == 4){
        mes = atoi(argv[2]);

        if(mes > 0 && mes <= 12){
            printf("%s de %s de %s", argv[1], meses[mes], argv[3]);
        }else
            printf("Mês inválido!");
    }else
        printf("Erro: Quantidade de parametros errada!");

    return 1;

}
