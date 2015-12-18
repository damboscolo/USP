#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int palindromo(char*, int);

int main(){

    printf("Essa string eh palindromo? R: %d", palindromo("abccba", 0));

    return 0;
}

int palindromo(char* str, int i){
    if(i > strlen(str)/2)
        return 1;
    else{
        if(str[i] != str[strlen(str)-i-1])
            return 0;
        else
            return palindromo(str, i+1);
    }
}
