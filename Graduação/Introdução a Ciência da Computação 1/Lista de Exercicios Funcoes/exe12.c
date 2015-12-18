#include <stdio.h>
#include <stdlib.h>

int fibonacci(int n);

int main(){

    int i;
    for(i = 0; i <= 20; i++){
        printf("%d", fibonacci(i));
        if(i < 20)
            printf(",");
    }

    return 0;
}

int fibonacci(int n){
    if(n <= 1)
        return 1;
    else
        return fibonacci(n-1) + fibonacci(n-2);
}
