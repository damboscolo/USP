#include "Palindromo.h"

int palindromo(char *str) {
    int i = 0, tam = 0;
    char *novaStr;
    while(str[i] != '\0'){
        tam++;
        i++;
    }
    novaStr = (char *) calloc(tam, sizeof(char));
    for(i = 0; i < tam; i++){
        novaStr[tam-i-1] = str[i];
    }
    if(strcmp(str, novaStr) == 0)
        return 1;
	return 0;
}
