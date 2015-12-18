#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{

    char fabricante[50], modelo[50], cor[20];
    int ano;
    float preco;

}Carro;

void modificaCarro(Carro *carro, int n);
void imprimeCarro(Carro *carro, int n);

int main(){

    Carro *carro;
    int n, i;

    printf("Digite numero de carros a serem cadastrados");
    scanf("%d", &n);
    carro = (Carro*) malloc(sizeof(Carro) * n);
    for(i = 0; i < n; i++){
        printf("Digite o fabricante do carro\n");
        scanf("%s", carro[i].fabricante);
        printf("Digite o modelo do carro\n");
        scanf("%s", carro[i].modelo);
        printf("Digite a cor do carro\n");
        scanf("%s", carro[i].cor);
        printf("Digite o ano do carro\n");
        scanf("%d", &carro[i].ano);
        printf("Digite o preco do carro\n");
        scanf("%f", &carro[i].preco);
    }

    modificaCarro(carro, n);
    imprimeCarro(carro, n);

    return 0;

}

void modificaCarro(Carro *carro, int n){
    int i;
    for(i = 0; i < n; i++){
        if(carro[i].ano < 2000)
            carro[i].ano = 2000;
        if(strcmp(carro[i].fabricante, "Chevrolet") == 0)
            strcpy(carro[i].fabricante, "GM");
    }
}

void imprimeCarro(Carro *carro, int n){
    int i;
    for(i = 0; i < n; i++){
        printf("O fabricante do carro eh: %s\n", carro[i].fabricante);
        printf("O modelo do carro eh: %s\n", carro[i].modelo);
        printf("O cor do carro eh: %s\n", carro[i].cor);
        printf("O ano do carro eh: %d\n", carro[i].ano);
        printf("O preco do carro eh: %0.2f\n\n", carro[i].preco);
    }
}
