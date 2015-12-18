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
#define TAM 10

typedef struct{
    float r,g,b;
}cor;

typedef struct{
    int valor, ativo, estado;
    float x, y, margin[4], movendo;
    cor c;
}elemento;

enum pos{POS_X, POS_Y, POS_BOTH};
enum margin{MARGIN_LEFT, MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM};
cor Cores[5];
elemento elems[TAM];
int valores[TAM], arrumado;
void mergeSort(int[], int, int);
void Desenha();
void Update();
void Inicializa();
void AlteraTamanhoJanela();
void reposiciona_elementos();
void DesenhaTitulo();
void Escreve(char*, cor, float, float, int);

int main(int argc, char** argv){

    srand ( time(NULL) );
    arrumado = 0;
    int i, valor;

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

    //Inicializa Elementos
    for(i = 0; i < TAM; i++){
        valor = rand() % 10;
        valores[i] = valor;
        elems[i].valor = valor;
        elems[i].ativo = 0;
        elems[i].c = Cores[1];
        elems[i].x = i*30.0f + 10.0f;
        elems[i].y = 490.0f;
        elems[i].margin[MARGIN_LEFT] = 0.0f;
        elems[i].margin[MARGIN_TOP] = 0.0f;
        elems[i].margin[MARGIN_RIGHT] = 0.0f;
        elems[i].margin[MARGIN_BOTTOM] = 0.0f;
    }
    reposiciona_elementos();

    glutInit_ATEXIT_HACK(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    glutInitWindowPosition(10, 10);
    glutCreateWindow("MergeSort");
    glutDisplayFunc(Desenha);
    glutIdleFunc(Update);
    glutReshapeFunc(AlteraTamanhoJanela);
    Inicializa();
    glutMainLoop();
    return 0;
}

Merge(int x[], int m1, int m2, int m3){
    int y[TAM];
    int apoint, bpoint, cpoint;
    int n1, n2, n3, i;
    apoint = m1; bpoint = m2+1;
    for( cpoint = m1; apoint <= m2 && bpoint <= m3; cpoint++){
        //Borda avermelhada para os elementos que estao sendo comparados
        elems[apoint].c = Cores[3];
        elems[bpoint].c = Cores[3];
        Desenha();
        Sleep(200);
        if (x[apoint] < x[bpoint]){
            elems[apoint].c = Cores[1];
            elems[bpoint].c = Cores[1];
            y[cpoint] = x[apoint++];
        }else{
            elems[apoint].c = Cores[1];
            elems[bpoint].c = Cores[1];
            y[cpoint] = x[bpoint++];
        }
        //Troca o valor
        elems[cpoint].valor = y[cpoint];
    }
    while (apoint <= m2){
        y[cpoint] = x[apoint++];
        elems[cpoint].valor = y[cpoint];
        cpoint++;
        Desenha();
        Sleep(200);
    }
    while (bpoint <= m3){
        y[cpoint] = x[bpoint++];
        elems[cpoint].valor = y[cpoint];
        cpoint++;
        Desenha();
        Sleep(200);
    }
    //Assim que os valores sao acertados, gravar na matriz original para a proxima junção
    for (i = m1; i <= m3; ++i) {
        if(y[i] >= 0 && y[i] < 10){
            x[i] = y[i];
            valores[i] = y[i];
            Sleep(200);
            Desenha();
        }
    }
}

void MergeSort(int v[], int esq, int dir){
    int q, i;
    float coord[2];
    if (esq < dir){
        q = floor((esq+dir)/2);
        //Divide no meio, usando margens
        elems[q].margin[MARGIN_RIGHT] = 5.0f;
        elems[q+1].margin[MARGIN_LEFT] = 5.0f;
        Sleep(500);
        Desenha();
        //Abaixa os elementos da metade esquerda
        for(i = esq; i <= q; i++){
            coord[1] = 50.0f;
            anima_elemento(POS_Y, coord, 300, &elems[i]);
            elems[i].estado++;
        }
        MergeSort(v, esq, q);
        // Abaixa os elementos da metade direita
        for(i = q+1; i <= dir; i++){
            coord[1] = 50.0f;
            anima_elemento(POS_Y, coord, 300, &elems[i]);
            elems[i].estado++;
        }
        MergeSort(v, q+1, dir);
        Merge(v, esq, q, dir);
        //Volta os elementos a posicao anterior
        for(i = esq;  i <= dir; i++){
            coord[1] = -50.0f;
            anima_elemento(POS_Y, coord, 300, &elems[i]);
            elems[i].estado--;
        }
        //Junta no meio os elementos, usando margens
        elems[q].margin[MARGIN_RIGHT] = 0.0f;
        elems[q+1].margin[MARGIN_LEFT] = 0.0f;
    }
}


void Update(){
    glClear(GL_COLOR_BUFFER_BIT);
    if(!arrumado){//Se o mergeSort ainda nao foi executado, execute
        arrumado = 1;
        MergeSort(valores, 0, TAM-1);
    }
}

void Desenha(){
     int i, j;
     cor Cor;
     char va[2];
     reposiciona_elementos();
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity();

     // Limpa a janela de visualização com a cor de fundo especificada
     glClear(GL_COLOR_BUFFER_BIT);

    //Desenha o Titulo da Aplicação
    DesenhaTitulo();

    //Cor Branca padrão
     glColor3f(1.0f, 1.0f, 1.0f);

     for(i = 0; i < TAM; i++){
        Cor = elems[i].c; //Pega a cor do elemento
        glColor3f(Cor.r, Cor.g, Cor.b); // Pinta o elemento de sua respectiva cor
        glBegin(GL_LINE_LOOP); // Começa desenho das linhas do contorno retangular
            glVertex2f(elems[i].x, elems[i].y);
            glVertex2f(elems[i].x, elems[i].y - 30.0f);
            glVertex2f(elems[i].x + 20.0f, elems[i].y - 30.0f);
            glVertex2f(elems[i].x + 20.0f, elems[i].y);
        glEnd();
        itoa(elems[i].valor, va, 10); // Transforma o numero de dentro em char*
        j = 0;
        glPushMatrix();
        glColor3f(1.0f, 1.0f, 1.0f); // Escreve em Branco sempre
        glRasterPos2f(elems[i].x + 8.0f, elems[i].y - 20.0f); //Reposiciona a posicao do opengl para desenhar a letra no lugar certo
        while(va[j] != '\0'){ //Desenha todos os char do valor
            glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24 , va[j]);
            j++;
        }
        glPopMatrix(); //Retorna a matriz a posição inicial
     }
     // Executa os comandos OpenGL
     glFlush();
}

// Inicializa parâmetros de rendering
void Inicializa (){
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); //Fundo Preto
}

// Função callback chamada quando o tamanho da janela é alterado
// Faz com que o espaço na tela seja 500.0f x 500.0f mesmo que sua proporção seja modificada
void AlteraTamanhoJanela(GLsizei w, GLsizei h){
    h = h==0?1:h;
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if(w <= h)
        gluOrtho2D(0.0f, 500.0f, 0.0f, 500.0f * h/w);
    else
        gluOrtho2D(0.0f, 500.0f * h/w, 0.0f, 500.0f);
}

//Posiciona os elementos no lugar correto assim que as margens e estados dos elementos mudam e eles precisam ser redesenhados
void reposiciona_elementos(){
    int i;
    float soma;
    for(i = 0; i < TAM; i++){ //Soma os tamanhos para centralizar os elementos na tela
        soma += 20.0f + elems[i].margin[MARGIN_LEFT] + elems[i].margin[MARGIN_RIGHT] + 2.0f;
    }
    for(i = 0; i < TAM; i++){
        if(elems[i].movendo == 0 && elems[i-1].movendo == 0){
            if(i > 0){//Utiliza a posicao do elemento anterior para posicionar o elemento atual
                elems[i].x = elems[i-1].x + 20.0f + elems[i-1].margin[MARGIN_RIGHT] + elems[i].margin[MARGIN_LEFT];
                elems[i].y = 460.0f - elems[i].estado * 50.0f;
            }else{//Posiciona o primeiro elemento no lugar correto (para centralizar tudo)
                elems[i].x = (350.0f - soma) / 2;
                elems[i].y = 460.0f - elems[i].estado * 50.0f - elems[i].margin[MARGIN_TOP];
            }
        }
    }
}

//Função para mover os elementos na horizontal, vertical ou as duas ao mesmo tempo
//Colocar coordenadas negativas para ir para cima ou esquerda e positivas para ir para direita e para baixo
//Utiliza incrementos de 1 em 1 dividido pelo tempo total da animação para movimentar 1 elemento
void anima_elemento(int pos, float coord[2], int tempo, elemento *e){
    int sleep;
    float dist, coordx, coordy;
    e->movendo = 1; //Marca que o bloco esta se movendo portanto sua posicao nao precisa ser recalculada pelo reposiciona_elementos();
    switch(pos){
        case POS_X:
            sleep = tempo / (coord[0]<0?-coord[0]:coord[0]); // Calcula o tempo entre cada incremento
            while(coord[0] != 0){
                if(coord[0] > 0){
                    e->x = e->x - 1;
                    coord[0]--;
                }else{
                    e->x = e->x + 1;
                    coord[0]++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
        case POS_Y:
            sleep = tempo / (coord[1]<0?-coord[1]:coord[1]); // Calcula o tempo entre cada incremento
            while(coord[1] != 0){
                if(coord[1] > 0){
                    e->y = e->y - 1;
                    coord[1]--;
                }else{
                    e->y = e->y + 1;
                    coord[1]++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
        case POS_BOTH:
            coordx = coord[0]<0?-coord[0]:coord[0];
            coordy = coord[1]<0?-coord[1]:coord[1];
            dist = coordx > coordy ? coordx : coordy; //Calcula a distancia entre o elemento e a posicao desejada
            sleep = tempo / dist; // Calcula o tempo entre cada incremento
            while(coord[0] != 0 || coord[1] != 0){
                if(coord[0] > 0){
                    e->x = e->x - 1;
                    coord[0]--;
                }else if(coord[0] < 0){
                    e->x = e->x + 1;
                    coord[0]++;
                }
                if(coord[1] > 0){
                    e->y = e->y - 1;
                    coord[1]--;
                }else if(coord[1] < 0){
                    e->y = e->y + 1;
                    coord[1]++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
    }
    e->movendo = 0; //Marca o elemento para ser reposicionado no lugar correto novamente assim que a animação acaba
}

void DesenhaTitulo(){
    char *titulo;
    titulo = "Merge Sort";
    cor c;
    c.r = 1.0f;
    c.g = 1.0f;
    c.b = 1.0f;
    Escreve(titulo, c, 150.0f, 480.0f, GLUT_BITMAP_TIMES_ROMAN_24);
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
}
