#include <stdio.h>

typedef struct{
    int hora;
    int minuto;
    int segundo;
}Horario;

typedef struct{
    int dia, mes, ano;
}Data;

typedef struct{
    Data data;
    Horario horario;
    char compromisso[500];
}Compromisso;

int main(){
    Compromisso c;
    printf("Digite o dia do compromisso\n");
    scanf("%d", &c.data.dia);
    printf("Digite o mes do compromisso\n");
    scanf("%d", &c.data.mes);
    printf("Digite o ano do compromisso\n");
    scanf("%d", &c.data.ano);
    printf("Digite a hora do compromisso\n");
    scanf("%d", &c.horario.hora);
    printf("Digite o minuto do compromisso\n");
    scanf("%d", &c.horario.minuto);
    printf("Difite os segundos do compromisso\n");
    scanf("%d", &c.horario.segundo);

    printf("O compromisso acontecerá em: %d-%d-%d %d:%d:%d", c.data.ano, c.data.mes, c.data.dia, c.horario.hora, c.horario.minuto, c.horario.segundo);

    return 0;

}
