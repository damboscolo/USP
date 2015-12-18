#include <stdio.h>

int contz(int v[4], int tam);

int main(){
    int v[4] = {0, 1, 0, 3};
    printf("Contz de 4 eh: %d", contz(v, 4));
    return 0;
}

int contz(int v[4], int tam){
    if(tam == 1){
        if(v[0] == 0)
            return 1;
        else
            return 0;
    }else{
        if(v[tam-1] == 0)
            return 1 + contz(v, (tam-1));
        else
            return contz(v,(tam-1));
    }
}
