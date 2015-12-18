#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{
    int n;
    char *nome;
    float media, n1, n2;
}Aluno;

typedef struct{
    Aluno *alunos;
    float media;
    int peso1, peso2, nalunos, inseridos;
}Turma;

Turma turma;

void escreveMenu();
void defineInfoTurma();
void inserirAluno();
void exibirAlunosMedias();
void exibirAprovados();
void exibirReprovados();
void menu();

int main(){

    menu();

    return 0;
}

void escreveMenu(){
    printf("\n\n\t Gerenciador de Alunos\n\nMenu:\n1 - Definir Informacoes da Turma\n2 - Inserir Aluno e Notas\n3 - Exibir alunos e medias\n4 - Exibir alunos Aprovados\n5 - Exibir alunos Reprovados\n6 - Sair\n\n");
}

void menu(){
    int op, i;
    do{
        escreveMenu();
        scanf("%d", &op);
        system("cls");
        switch(op){
            case 1:
                defineInfoTurma();
                break;
            case 2:
                inserirAluno();
                break;
            case 3:
                exibirAlunosMedias();
                break;
            case 4:
                exibirAprovados();
                break;
            case 5:
                exibirReprovados();
                break;
            default:
                printf("Comando Invalido\n");
                break;
        }
    }while(op != 6);
    if(op == 6){
        for(i = 0; i < turma.nalunos; i++){
            free(turma.alunos[i].nome);
        }
        free(turma.alunos);
    }
}

void defineInfoTurma(){
    printf("Digite o numero de Alunos nessa turma\n");
    scanf("%d", &turma.nalunos);
    turma.alunos = malloc (sizeof(Aluno)*turma.nalunos);
    printf("Digite a media de aprovacao\n");
    scanf("%f", &turma.media);
    printf("Digite o peso da primeira nota\n");
    scanf("%d", &turma.peso1);
    printf("Digite o peso da segunda nota\n");
    scanf("%d", &turma.peso2);
    printf("Informacoes da turma salvas\n");
}

void inserirAluno(){
    if(turma.inseridos < turma.nalunos){
        int i = turma.inseridos;
        char nome[100];
        Aluno a;
        printf("Digite o numero do aluno a ser inserido\n");
        scanf("%d", &a.n);
        printf("Digite o nome do aluno a ser inserido\n");
        scanf("%s", &nome);
        a.nome = malloc(strlen(nome)+1);
        strcpy(a.nome, nome);
        printf("Digite o valor da primeira nota do aluno\n");
        scanf("%f", &a.n1);
        printf("Digite o valor da segunda nota do aluno\n");
        scanf("%f", &a.n2);
        a.media = ((turma.peso1 * a.n1) + (turma.peso2 * a.n2)) / ( turma.peso1 + turma.peso2);
        printf("%0.2f", a.media);
        turma.alunos[i] = a;
        turma.inseridos++;
        printf("Aluno inserido com sucesso!\n");
    }else
        printf("Turma Lotada \n");
}

void exibirAlunosMedias(){
    int i, max;
    max = turma.inseridos;
    for(i = 0; i < max; i++){
        printf("O Aluno %s tem media %f\n", turma.alunos[i].nome, turma.alunos[i].media);
    }
}

void exibirAprovados(){
    int i, max;
    max = turma.inseridos;
    for(i = 0; i < max; i++){
        if(turma.alunos[i].media >= turma.media)
            printf("O Aluno %s esta aprovado\n", turma.alunos[i].nome);
    }
}

void exibirReprovados(){
    int i, max;
    max = turma.inseridos;
    for(i = 0; i < max; i++){
        if(turma.alunos[i].media < turma.media)
            printf("O Aluno %s esta reprovado\n", turma.alunos[i].nome);
    }
}
