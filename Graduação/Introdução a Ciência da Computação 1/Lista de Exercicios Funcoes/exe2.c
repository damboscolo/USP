#include <stdio.h>
#include <stdlib.h>

int elevado(int x, int y);

int main(){

    elevado(2,3);

    return 0;
}

int elevado(int x, int y){
    int res = x, i;
    for(i = 0; i < (y-1); i++){
        res *= x;
    }
    printf("%d elevado a %d eh: %d", x, y, res);
}
