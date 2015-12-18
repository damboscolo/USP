#include <stdio.h>
#include <stdlib.h>

int main(){

    int dia, mes, ano, erro = 0;

    printf("Digite a data no seguinte formato dd/mm/aaaa\n\n");
    scanf("%d/%d/%d", &dia, &mes, &ano);

    if(ano > 2012 || ano <= 0)
        erro++;
    if(mes > 12 || mes <= 0)
        erro++;
    if(((dia > 29 && (ano % 4) == 0) || (dia > 28 && (ano % 4) > 0)) && mes == 2)
        erro++;
    if(mes <= 7 && dia > (30 + mes%2))
        erro++;
    if(mes > 7 && dia > (31 - mes%2))
        erro++;
    if(dia <= 0)
        erro++;

    if(erro == 0)
        printf("\nSua data eh valida");
    else
        printf("\nSua data eh invalida");
    return 0;
}
