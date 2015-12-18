#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>

#define SCREEN_WIDTH 1050
#define SCREEN_HEIGHT 700
#define SCREEN_FPS 60
#define TAM 50
#define DELAY 50

typedef struct{
    float r,g,b;
}cor;

cor Cores[5];
void quickSort(int[][2], int, int);
void desenha();
void update();
int valores[TAM][2], arrumado;
void Desenha();
void Update();
void Inicializa();
void AlteraTamanhoJanela();
void DesenhaTitulo();
void DesenhaLegenda();
void Escreve(char*, cor, float, float, int);

int main(int argc, char** argv){

    srand ( time(NULL) );
    arrumado = 0;
    int i;

    //Cinza
    Cores[0].r = 0.7f;
    Cores[0].g = 0.7f;
    Cores[0].b = 0.7f;
    //Branco
    Cores[1].r = 1.0f;
    Cores[1].g = 1.0f;
    Cores[1].b = 1.0f;
    //Azul Claro
    Cores[2].r = 0.18f;
    Cores[2].g = 0.57f;
    Cores[2].b = 1.0f;
    //Vermelho Claro
    Cores[3].r = 1.0f;
    Cores[3].g = 0.18f;
    Cores[3].b = 0.18f;
    //Verde Claro
    Cores[4].r = 0.57f;
    Cores[4].g = 1.0f;
    Cores[4].b = 0.18f;

    for(i = 0; i < TAM; i++){
        valores[i][0] = rand() % 220;
        valores[i][1] = 0;
    }

    glutInit_ATEXIT_HACK(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    glutInitWindowPosition(10, 10);
    glutCreateWindow("Quadrado");
    glutDisplayFunc(Update);
    glutReshapeFunc(AlteraTamanhoJanela);
    Inicializa();
    glutMainLoop();
    return 0;
}

void troca(int *a, int *b){
    int aux;
    aux = *a;
    *a = *b;
    *b = aux;
}

int particiona(int v[][2], int esq, int dir){
    int a, cima, baixo, i;

    a = v[esq][0];
    valores[esq][1] = 1;//Coloca como ativo o pivo da troca
    cima = dir;
    baixo = esq;
    while(baixo < cima){ // Enquanto o de baixo for menor q o de cima continua trocando
        valores[esq][1] = 1;
        while(v[baixo][0] <= a && baixo < dir){ // se o v na posicao baixo for menor q o valor escolhido e o baixo estiver menor q o final baixo eh incrementado
            valores[baixo][1] = 2;
            Desenha();
            Sleep(DELAY);
            valores[baixo][1] = 0;
            baixo++;
        }
        valores[esq][1] = 1;
        valores[baixo][1] = 2;
        while(v[cima][0] > a){// se v cima for maior que a pega o proximo alto
            valores[cima][1] = 3;
            Desenha();
            Sleep(DELAY);
            valores[cima][1] = 0;
            cima--;
        }
        valores[esq][1] = 1;
        valores[cima][1] = 3;
        if(baixo < cima){ // Se o baixo for menor q o cima troca a posicao dos seus valores
            valores[baixo][1] = 4;
            valores[cima][1] = 4;
            Desenha();
            Sleep(DELAY);
            troca(&v[baixo][0], &v[cima][0]);
        }
        Desenha();
        Sleep(floor(DELAY*2.5));
        valores[baixo][1] = 0;
        valores[cima][1] = 0;
    }
    v[esq][0] = v[cima][0]; //Troca o valor inicial com o valor final do de cima
    valores[esq][1] = 0;
    v[cima][0] = a; // O valor do de cima eh o valor inicial
    return cima;
}

void quickSort(int v[][2], int esq, int dir) {
  int r;

  if (dir > esq) {
    r = particiona(v, esq, dir); // Particiona o vetor e ordena
    quickSort(v, esq, r - 1); // Pega a parte esquerda e aplica a mesma funcao
    quickSort(v, r + 1, dir); // Pega a parte direita e aplica a mesma funcao
  }
}

void Update(){
    glClear(GL_COLOR_BUFFER_BIT);
    if(!arrumado){ //Se o quicksort nao foi executado, execute
        arrumado = 1;
        quickSort(valores, 0, TAM-1);
    }else{
        Desenha();
    }
}

void Desenha(){
     int i, j;
     cor Cor;
     char va[4];
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity();

     // Limpa a janela de visualização com a cor de fundo especificada
     glClear(GL_COLOR_BUFFER_BIT);

     glColor3f(1.0f, 1.0f, 1.0f);

     glLineWidth(14.0f); //Altera a largura das linhas para 14

     for(i = 0; i < TAM; i++){
        Cor = Cores[valores[i][1]]; //Pega a cor da barra atual
        glColor3f(Cor.r, Cor.g, Cor.b); //Pinta a barra da cor pega
        glBegin(GL_LINES); //Começa a desenhar linha (de largura 14 que parece uma barra)
            glVertex2i(2+i*3, 7);
            glVertex2i(2+i*3, 7 +(valores[i][0]));
        glEnd();
        itoa(valores[i][0], va, 10);// Transforma o valor da barra em char*
        Escreve(&va, Cores[1], 1.0f+i*3.0f, 2.0f, GLUT_BITMAP_TIMES_ROMAN_10);
     }
     DesenhaTitulo(); //Desenha o titulo da aplicação
     DesenhaLegenda(); //Desenha as legendas para ajudar a entender o que está acontecendo
     // Executa os comandos OpenGL
     glFlush();
}

// Inicializa parâmetros de rendering
void Inicializa (){
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

// Função callback chamada quando o tamanho da janela é alterado
void AlteraTamanhoJanela(GLsizei w, GLsizei h){
    h = h==0?1:h;
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if(w <= h)
        gluOrtho2D(0.0f, 250.0f, 0.0f, 250.0f * h/w);
    else
        gluOrtho2D(0.0f, 250.0f * h/w, 0.0f, 250.0f);
}

void DesenhaTitulo(){
    char *titulo;
    titulo = "Quick Sort";
    cor c;
    c.r = 1.0f;
    c.g = 1.0f;
    c.b = 1.0f;
    Escreve(titulo, c, 70.0f, 240.0f, GLUT_BITMAP_TIMES_ROMAN_24);
}

void Escreve(char *texto, cor c, float x, float y, int fonte){
    int i;
    //Muda a cor do Texto
    glColor3f(c.r, c.g, c.b);
    i = 0;
    glPushMatrix();
    glRasterPos2f(x, y); //Reposiciona a posicao do opengl para desenhar a letra no lugar certo
    while(texto[i] != '\0'){ //Desenha todos os char do valor
        glutBitmapCharacter(fonte , texto[i]);
        i++;
    }
	glPopMatrix();//Retorna a matriz a posição inicial
}

void DesenhaLegenda(){
    cor Cor;
    int i;
    char *legenda[5];
    legenda[0] = "Normal";
    legenda[1] = "Pivo";
    legenda[2] = "Indice Menor";
    legenda[3] = "Indice Maior";
    legenda[4] = "Troca";
    glLineWidth(14.0f);
     for(i = 0; i < 5; i++){
        Cor = Cores[i]; //Pega a cor da barra atual
        glColor3f(Cor.r, Cor.g, Cor.b); //Pinta a barra da cor pega
        glBegin(GL_LINES); //Começa a desenhar linha (de largura 14 que parece uma barra)
            glVertex2i(1+i*11, 245);
            glVertex2i(11+i*11, 245);
        glEnd();
        Cor.r = 0.0f;
        Cor.g = 0.0f;
        Cor.b = 0.0f;
        Escreve(legenda[i], Cor, 2+i*11, 244, GLUT_BITMAP_TIMES_ROMAN_10);
     }
}
