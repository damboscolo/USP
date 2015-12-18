#include <stdio.h>

void le_notas(int nusp);
float calc_media(int peso);
float n1 = 0.0f, n2 = 0.0f, n3 = 0.0f;

int main(){

    int i, nusp;
    float media;

    for(i = 1; i < 11; i++){
        printf("Digite o numero USP do aluno %d:\n", i);
        scanf("%d", &nusp);
        le_notas(nusp);
        media = calc_media(i>5?1:0);
        printf("A media do aluno %d eh %f\n", nusp, media);
    }

    return 0;

}

void le_notas(int nusp){
    printf("Digite a primeira nota:\n");
    scanf("%f", &n1);
    printf("Digite a segunda nota:\n");
    scanf("%f", &n2);
    printf("Digite a terceira nota:\n");
    scanf("%f", &n3);
}

float calc_media(int peso){
    float media;
    if(peso == 1){
        media = (n1 + (2*n2) + (3*n3)) / 6;
    }else{
        media = (n1 + n2 + n3) / 3;
    }
    return media;
}
