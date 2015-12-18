#include <stdlib.h>
#include <stdio.h>

void hanoi(int n, char origem, char destino, char auxiliar){
    if(n == 1)
        printf("\nMover disco 1 de %c para %c", origem, destino);
    else{
        hanoi(n-1, origem, auxiliar, destino);
        printf("\nMover disco %d de %c para %c", n, origem, destino);
        hanoi(n-1, auxiliar, destino, origem);
    }
}

int main(){

    int n;

    printf("Digite o numero de discos na torre de hanoi\n");
    scanf("%d", &n);

    hanoi(n, 'A', 'B', 'C');

}
