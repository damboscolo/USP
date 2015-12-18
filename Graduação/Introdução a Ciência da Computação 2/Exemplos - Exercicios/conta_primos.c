#include <stdio.h>
#include <stdlib.h>

int primo(int, int);
int conta_primos(int, int);

int main(){

    printf("%d", conta_primos(6, 12));

    return 0;
}

int primo(int x, int j){
    if(j > x/2){
        return 1;
    }else{
        if(x%j == 0)
            return 0;
        else
            return primo(x, j+1);
    }
}

int conta_primos(int a, int b){
    if(b == a){
        return primo(b, 2);
    }else{
        return primo(b, 2) + conta_primos(a, b-1);
    }
}
