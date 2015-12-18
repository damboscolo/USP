#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{
    char *nome;
    int codigo;
    float preco;
}Prato;

typedef struct{
    int pratos[3];
    float preco;
}Combinado;

Prato cadastra_prato(int n);
Combinado *cadastra_combinado(Prato pratos[6], int n, int tam);

int main(){

    Prato pratos[6], rpratos[3];
    Combinado *combinados;
    int i,j;
    combinados = (Combinado*) malloc(4*sizeof(Combinado));
    printf("Cadastro de pratos\n\n");
    for(i = 0; i < 3; i++){
        cadastra_prato(i);
    }
    printf("\n\nCadastro de Combinacoes\n\n");
    for(j = 0; j < 4; j++){
        combinados = cadastra_combinado(pratos, 4, 6);
    }
    free(combinados);
    return 0;

}


Prato cadastra_prato(int n){
    char nome[100];
    int codigo, i = 0;
    float preco;
    Prato prato;
    printf("Digite o nome do prato %d", n);
    gets(nome);
    printf("Digite o codigo do prato %d", n);
    scanf("%d", &codigo);
    printf("Digite o preco do prato %d", n);
    scanf("%f", &preco);
    prato.nome = (Prato.nome*) malloc(100*sizeof(Prato.nome));
    prato.nome = nome;
    prato.codigo = codigo;
    prato.preco = preco;
    return prato;
}

Combinado *cadastra_combinado(Prato pratos[6], int n, int tam){
    Combinado combinado[4];
    int i, j, k, l rand, randomizados[3], nrand = 0, erro = 0;
    float precoTotal = 0.0f;
    Pratro rpratos[3];
    for(l = 0; l < 4; l++){
        for(i = 0; i < 3; i++){
            if(nrand > 0){
                erro = 0;
                do{
                    rand = random(tam-1);
                    for(j = 0; j <= nrand; j++){
                        if(rand == randamizados[j])
                            erro++
                    }
                }while(erro == 0 && j == nrand);
            }else
                rand = random(tam-1);

            randomizados[i] = rand;
            rpratos[i] = pratos[rand];
        }
        for(k = 0; k < 4; i++){
            precoTotal += rpratos[k].preco;
        }
        precoTotal *= 0.9;
        combinado[l].preco = precoTotal;
        combinado[l].pratos = rpratos;
    }
    return combinado;
}
