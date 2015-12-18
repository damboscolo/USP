#include <stdio.h>

torre_hanoi(int n, int ori, int des, int aux);

int main(){
    torre_hanoi(3, 'o', 'd', 'a');
}

torre_hanoi(int n, int ori, int des, int aux){
    if(n == 1){
        printf("move disco %d de %c para %c\n", n, ori, aux);
    }else{
        torre_hanoi(n-1, ori, aux, des);
        printf("Move disco %d de %c para %c\n", n, ori, aux);
        torre_hanoi(n-1, des, ori, aux);
    }
}
