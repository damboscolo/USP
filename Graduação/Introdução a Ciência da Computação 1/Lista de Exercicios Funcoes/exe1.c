#include <stdio.h>
#include <stdlib.h>

int maior(int n1, int n2, int n3);

int main(){

    int n;
    n = maior(10, 5, 18);
    printf("%d", n);
    return 0;
}


int maior(int n1, int n2, int n3){
    if(n1 > n2){
        if(n1 > n3)
            return n1;
        else
            return n3;
    }else{
        if(n2 > n3)
            return n2;
        else
            return n3;
    }
}
