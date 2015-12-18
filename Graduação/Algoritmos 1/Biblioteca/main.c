/*
*   Algoritmos e Estrutura de Dados I - Profº Thiago Pardo
*
*            BIBLIOTECA - 22/08/2012
*
*       Daniele Hidalgo Boscolo   (nº USP: 7986625)
*       Eduardo Sigrist Ciciliato (nº USP: 7986542)
*/
#include "fila.h"
#include <string.h>
#define TAMBIBLIO 100

typedef struct{
    char nomeLivro[100], autor[100];
    int disponivel;
    Fila filaEspera;
}Livro;

void cadastraLivro(Livro *l, char *nome, char *autor){
    strcpy(l->nomeLivro, nome);
    strcpy(l->autor, autor);
    l->disponivel = 0;
    cria(&l->filaEspera);
    printf("\nLivro cadastrado com sucesso!\n");
}

Livro* buscaLivro(Livro *biblioteca, char *busca){
    int i;
    Livro temp;
    for(i=0;i<TAMBIBLIO;i++){
        temp = biblioteca[i];
        if(strcmp(busca, temp.nomeLivro)==0 ){
            return &biblioteca[i];
        }
    }
    //return -1;
}

void deletaLivro(Livro *biblioteca, char *livro){
    Livro *l;
    l = buscaLivro(biblioteca, livro);

    strcpy(l->nomeLivro,"");
    strcpy(l->autor,"");
    l->disponivel = 0;
    esvaziar(l);
    printf("\nLivro deletado com sucesso!\n");
}

void RequisitarLivro(Livro *biblioteca, char *livro, elm *pessoa){
    int erro;
    Livro *l;
    l = buscaLivro(biblioteca, livro);

    if(l->disponivel == 0){//esta disponivel
        l->disponivel == 1;
        printf("\nLivro alugado com sucesso!\n");
    }else{
        entra(&l->filaEspera, pessoa,&erro);
        if(erro == 1){
            printf("Livro indisponivel. Erro ao tentar colocar na fila de espera!\n");
        }else{
            printf("\nLivro indisponivel. Voce esta na fila de espera!\n");
        }
    }
}

void devolverLivro(Livro *biblioteca, char *livro){
    int erro;
    elm pessoa;
    Livro *l;
    l = buscaLivro(biblioteca, livro);

    if(estaVazia(&l->filaEspera)){
        l->disponivel = 0;
    }else{
        sai(&l->filaEspera, &pessoa, &erro);
        if(erro == 1){
            printf("\nErro ao passar o livro ao proximo da fila.\n");
        }else{
            printf("\nLivro devolvido com sucesso.\n");
        }
    }
}


void leInfo(char **valor, char *escreve){
    char tmp[100];
    int tam;
    printf("%s", escreve);
    scanf("%s", tmp);
    tam = strlen(tmp)+1;
    *valor = (char*) malloc(tam*sizeof(char));
    strcpy(*valor, tmp);
}

int main(){
    Livro biblioteca[TAMBIBLIO];
    int op=0, pos=0;
    char *nome, *autor, *procura, *email;
    elm pessoa;

     while(op != 53){
            printf("MENU:\n1- Cadastrar Livro\n2- Deletar Livro\n3- Requisitar\n4- Devolver\n5- Sair\n\n");
            op = getch();
            system("cls");
            switch(op){
                case 49:
                    printf("Cadastrando Livro\n\n");
                    leInfo(&nome, "Digite o nome:\n");
                    leInfo(&autor, "Digite o autor:\n");
                    system("cls");
                    cadastraLivro(&biblioteca[pos++], nome, autor);
                    break;
                case 50:
                    printf("Deletando Livro\n\n");
                    leInfo(&procura, "Digite o nome do livro a ser removido:\n");
                    system("cls");
                    deletaLivro(&biblioteca, &procura);
                    break;
                case 51:
                    printf("Requisitando Livro\n\n");
                    leInfo(&procura, "Digite o nome do livro:\n");
                    leInfo(&nome, "Digite seu nome:\n");
                    leInfo(&email, "Digite seu email:\n");
                    strcpy(pessoa.nome, nome);
                    strcpy(pessoa.email, email);
                    system("cls");
                    RequisitarLivro(&biblioteca, &procura, &pessoa);
                    break;
                case 52:
                    printf("Devolvendo Livro\n\n");
                    leInfo(&procura, "Digite o nome do livro:\n");
                    system("cls");
                    devolverLivro(&biblioteca, &procura);
                    break;
            }
        }
    return 0;
}

