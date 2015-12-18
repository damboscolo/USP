#include <stdio.h>
#include <stdlib.h>

int busca(int inicio, int fim, int x);

int vetor[20] = {14, 6, 19, 3, 60, 234, 2, 35, 54, 1, 4, 55, 23, 5, 71, 0, 13, 28, 92, 7};

int main(){

    int res, n;

    printf("Digite o numero a ser buscado\n");
    scanf("%d", &n);

    res = busca(0, 19, n);
    if(res == -1)
        printf("O numero %d nao foi encontrado no vetor", n);
    else
        printf("O numero %d esta na posicao %d do vetor", n, res);

    return 0;
}


int busca(int inicio, int fim, int x){
    if(inicio < fim){
        if(vetor[inicio] == x)
            return inicio;
        else
            busca(inicio+1, fim, x);
    }else
        return -1;

}
