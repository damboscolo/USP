#include <stdio.h>

//Prot�tipo da fun��o de fibonacci
int fibonacci(int n);

int main(){
    printf("Fibonacci de 20 eh:\n");
    //Imprime fibonacci de 20
    printf("%d", fibonacci(20));
    return 0;
}

/*
*   Fibonacci
*   Fun�ao que calcula o valor de uma s�rie de Fibonacci
*   Entradas: int n - numero a ser procurado na sequ�ncia
*   Saida: int resultado - resultado do valor entrado na fun��o
*/
int fibonacci(int n){
    if(n == 0 || n == 1)
        return 1;
    else
        return fibonacci(n-1) + fibonacci(n-2);
}
