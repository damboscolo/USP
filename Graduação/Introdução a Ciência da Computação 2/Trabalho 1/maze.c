/*
Nome : Eduardo S. Ciciliato
N USP: 7986542
*/
#include <stdio.h>
#include <stdlib.h>

//Prototipos
void print_maze(int[10][10]);
void print_caminho(int[100][2], int);
void resolve_maze(int[10][10], int, int, int, int[50][2], int);

int main(){

    int maze_a[10][10] = { // Declara o labirinto
    {0,1,0,0,0,1,0,0,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,0,0,1,0,1,0,1,0,1},
    {1,1,1,1,0,1,0,1,0,1},
    {0,0,0,0,0,1,0,1,0,1},
    {1,0,1,1,1,1,0,1,0,1},
    {1,0,0,0,0,0,0,1,0,1},
    {1,0,1,1,1,1,1,1,0,0}
    };
    int maze_b[10][10] = { // Declara o labirinto
    {0,1,0,0,0,1,0,0,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,1,0,1,0,1,0,1,0,1},
    {0,0,0,1,0,0,0,1,0,0}
    };
    int maze_c[10][10] = { // Declara o labirinto
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {1,1,1,1,1,1,1,1,0,1},
    {0,0,0,0,0,0,0,0,0,1},
    {0,1,1,1,1,1,1,1,1,1},
    {0,0,0,0,0,0,0,0,1,1},
    {1,1,1,1,1,1,0,1,1,1},
    {0,0,0,0,0,0,0,1,1,1},
    {0,1,1,1,1,1,1,1,1,1},
    {0,0,0,0,0,0,0,0,0,0}
    };
    int maze_d[10][10] = { // Declara o labirinto
    {0,0,0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0,0,0},
    {1,1,1,1,1,1,1,1,0,1},
    {0,0,0,0,0,0,0,0,0,1},
    {0,1,1,1,1,1,1,1,1,1},
    {0,0,0,0,0,0,0,0,1,1},
    {1,1,1,1,1,1,0,1,1,1},
    {0,0,0,0,0,0,0,1,1,1},
    {0,1,1,1,1,1,1,1,1,1},
    {0,0,0,0,0,0,0,0,1,1}
    };

    int caminho[100][2]; // Declara variavel para guardar o caminho

    printf("Resoluçao do labirinto\n");

    print_maze(maze_d); // Mostra o labirinto na tela

    resolve_maze(maze_d, 0, 0, 0, caminho, 0); // Resolve recursivamente o labirinto

    return 0;
}

void print_maze(int v[10][10]){ // Funçao para mostrar na tela o labirinto
    int i, j;
    for(i = 0; i < 10; i++){
        for(j = 0; j < 10; j++){
            printf("%d ", v[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void print_caminho(int v[100][2], int tam){ // Funçao para mostrar na tela os passos que a funçao de resolver labirinto usou para chegar ao final
    int i, j;
    for(i = 0; i < tam; i++){
        for(j = 0; j < 2; j++){
            printf("%d ", v[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void resolve_maze(int maze[10][10], int i, int j, int ant, int caminho[100][2], int movimentos){
    if(movimentos >= 100){ // Se chegar ao maximo de movimentos (no caso de loops infinitos) declara o labirinto como sem soluçao
        print_caminho(caminho, ant); // Mostra onde o caminho acaba, quando nao tem solucao
        printf("Nao tem solucao\n");
    }else if(i == 9 && j == 9){ // Se chegar ao final
        printf("Labirinto resolvido\n\n");
        printf("Caminho feito:\n");
        print_caminho(caminho, ant); // Mostra o caminho feito para chegar no final do labirinto
    }else{
        //Verifica se os ultimos 3 movimentos forem os mesmos e da o labirinto como sem solucao
        if(caminho[ant-1][0] == caminho[ant-2][0] && caminho[ant-2][0] == caminho[ant-3][0] && caminho[ant-1][1] == caminho[ant-2][1] && caminho[ant-2][1] == caminho[ant-3][1]){
            resolve_maze(maze, i, j, ant, caminho, movimentos+100);
        }else{
            // Verifica se é possivel andar para baixo e verifica repetiçao de movimento para nao ficar subindo e descendo
            if(maze[i+1][j] == 0 && i+1 <= 9 && caminho[ant-2][0] != i+1){
                i++; //Anda uma casa para baixo
            // Verifica se é possivel andar para direita e verifica repetiçao de movimento para nao ficar indo para direita e esquerda
            }else if(maze[i][j+1] == 0 && j+1 <= 9 && caminho[ant-2][1] != j+1){
                j++; //Anda uma casa para direita
            // Verifica se é possivel andar para cima e verifica repetiçao de movimento para nao ficar subindo e descendo
            }else if(maze[i-1][j] == 0 && i-1 >= 0 && caminho[ant-2][0] != i-1){
                i--; //Anda uma casa para baixo
            // Verifica se é possivel andar para esquerda e verifica repetiçao de movimento para nao ficar indo para direita e esquerda
            }else if(maze[i][j-1] == 0 && j-1 >= 0 && caminho[ant-2][1] != j-1){
                j--; //Anda uma casa para esquerda
            }
            caminho[ant][0] = i; //Guarda o movimento vertical na matriz de caminho
            caminho[ant][1] = j; //Guarda o movimento horizontal na matriz de caminho
            resolve_maze(maze, i, j, ant+1, caminho, movimentos+1); // Chama recursivamente o proximo passo para resolver o labirinto
        }
    }
}
