#include <stdio.h>
#include <stdlib.h>

int fatorial(int n);
int primo(int n, int j);

int main(){

    int n, fat;
    scanf("%d", &n);
    fat = fatorial(n);
    if(primo(fat, 2) == 1)
        printf("%d que tem o fatorial valendo %d eh primo", n, fat);
    else
        printf("%d que tem o fatorial valendo %d nao eh primo", n, fat);

    return 0;
}

int fatorial(int n){
    if(n <= 1)
        return 1;
    else
        return n * fatorial(n-1);
}

int primo(int n, int j){
    if(j > (n/2))
        return 1;
    else if((n % j) == 0)
        return 0;
    else
        return primo(n, (j+1));

}
