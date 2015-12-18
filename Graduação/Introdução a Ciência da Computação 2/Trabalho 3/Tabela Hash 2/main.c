#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <GL/freeglut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include "hash.h"

#define SCREEN_WIDTH 1585
#define SCREEN_HEIGHT 850
#define SCREEN_FPS 60
#define TAM 26

enum modo{INICIO, ADICIONA, REMOVE, BUSCA};
enum teclas{KEY_1=49, KEY_2=50, KEY_3=51};
enum erros{ERRO_ADICIONAR, ERRO_REMOVER, ERRO_BUSCAR};

int mode, keypress, keys[256], uver, letra, enter, escreveu, erroflag, destaque;
char *erromsg[3];
hash h;
tela *t;
tabelahash *th;
Cor Cores[5];
elemento elems[TAM];
int valores[TAM], arrumado;

void Desenha();
void Update();
void Idle();
void Timer();
void Keyboard(unsigned char, int, int);
void KeyboardUp(unsigned char, int, int);
void SpecialKeys(int, int, int);
void Inicializa();
void AlteraTamanhoJanela();
void DesenhaTitulo();
void DesenhaMenu();
void DesenhaTabela();

int main(int argc, char** argv){

    int i, valor;
    mode = INICIO;
    keypress = 1;
    letra = 0;
    enter = 0;
    arrumado = 0;
    uver = 0;
    escreveu = 0;
    erroflag = -1;
    destaque = -1;

    erromsg[ERRO_ADICIONAR] = "Erro ao tentar adicionar musica";
    erromsg[ERRO_REMOVER] = "Erro ao tentar remover musica";
    erromsg[ERRO_BUSCAR] = "Erro musica nao encontrada";

    criaCorf(&Cores[0], 0.7f, 0.7f, 0.7f);//Cinza
    criaCorf(&Cores[1], 1.0f, 1.0f, 1.0f);//Branco
    criaCorf(&Cores[2], 0.18f, 0.57f, 1.0f);//Azul Claro
    criaCorf(&Cores[3], 1.0f, 0.57f, 0.18f);//Vermelho Claro
    criaCorf(&Cores[4], 0.57f, 1.0f, 0.18f);//Verde Claro

    h.indice = 0;
    h.m = 100;
    for(i = 0; i < 30; i++){
        h.mcores[i] = Cores[1];
        h.pcores[i] = Cores[1];
    }
    t = (tela*) malloc(sizeof(tela));
    t->topo_b = -1;
    t->topo_e = -1;
    t->topo_s = -1;
    t->boxes = (box*) malloc(sizeof(box) * 100);
    t->escritas = (escrita*) malloc(sizeof(escrita) * 100);
    t->setas = (seta*) malloc(sizeof(seta) * 100);
    t->underscore = (point*) malloc(sizeof(point));
    setPointi(t->underscore, 11, 582);

    th = (tabelahash*) malloc(sizeof(tabelahash));
    th->m = 13;
    th->vazio = 13;
    for(i = 0; i < 30; i++){
        th->musicas[i] = (musica*) malloc(sizeof(musica));
        th->musicas[i]->prox = -1;
        th->musicas[i]->nome = NULL;
        th->temp[i] = (musica*) malloc(sizeof(musica));
        th->temp[i]->prox = -1;
        th->temp[i]->nome = NULL;
    }

    srand ( time(NULL) );

    glutInit_ATEXIT_HACK(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    glutInitWindowPosition(0, 0);
    glutCreateWindow("Tabela Hash");
    glutDisplayFunc(Desenha);
    glutIdleFunc(Update);
    glutKeyboardFunc(Keyboard);
    glutKeyboardUpFunc(KeyboardUp);
    glutSpecialFunc(SpecialKeys);
    glutReshapeFunc(AlteraTamanhoJanela);
    glutIdleFunc(Idle);
    glutTimerFunc(1000, Timer, 100);
    Inicializa();
    glutMainLoop();
    return 0;
}


void Update(){
    glClear(GL_COLOR_BUFFER_BIT);
    switch(mode){
        case INICIO:
            if(keys[KEY_1]){
                mode = ADICIONA;
                box *b;
                if(t->topo_b<0)
                    box_cria(&b, 9, 579, 52, 18, 1.0f, 1.0f, 1.0f);
                else{
                    box *ant;
                    ant = t->boxes[t->topo_b];
                    box_cria(&b, ant->a->xi + ant->a->widthi + 5, 579, 52, 18, 1.0f, 1.0f, 1.0f);
                    setPointf(t->underscore, ant->a->xf + ant->a->widthf + 7.0f, 582.0f);
                }
                tela_add_box(&t, b);
                keys[KEY_1] = 0;
            }else if(keys[KEY_2]){
                mode = REMOVE;
                setPointf(t->underscore, 92.0f, 622.0f);
                keys[KEY_2] = 0;
            }else if(keys[KEY_3]){
                mode = BUSCA;
                setPointf(t->underscore, 92.0f, 622.0f);
                keys[KEY_3] = 0;
            }
            break;
        case ADICIONA:
            if(keys[KEY_1] || enter){
                enter = 0;
                int erro;
                hash_insere(&th, &t->escritas[t->topo_e]->x, &erro, Desenha);
                mode = INICIO;
                keys[KEY_1] = 0;
            }else if(keys[KEY_2]){
                mode = INICIO;
                t->boxes[t->topo_b--] = NULL;
                t->escritas[t->topo_e--] = NULL;
            }
            if(letra > 0){
                escrita *e;
                char *fletra;
                if(t->topo_b > t->topo_e){
                    fletra = (char*) malloc(sizeof(char)*4);
                    char temp[2] = {(char)letra, '\0'};
                    strcpy(fletra, temp);
                    escrita_cria(&e, fletra, t->boxes[t->topo_b]->a->xi+2 , 584);
                    tela_add_escrita(&t, e);
                }else{
                    char temp[2] = {(char)letra, '\0'};
                    strcat(t->escritas[t->topo_e]->x, temp);
                }
                t->underscore->xi += 2;
                t->underscore->xf += 2.3f;
                letra = 0;
            }else if(letra < 0){
                int length = strlen(t->escritas[t->topo_e]->x);
                if(t->topo_b <= t->topo_e && length > 0){
                    char temp[length-1];
                    strncpy(temp, t->escritas[t->topo_e]->x, length-1);
                    temp[length-1] = '\0';
                    strcpy(t->escritas[t->topo_e]->x, temp);
                    t->underscore->xi -= 2;
                    t->underscore->xf -= 2.3f;
                }
                letra = 0;
            }
            break;
        case REMOVE:
            if(keys[KEY_1] || enter){
                char *nome;
                enter = 0;
                int erro = 0, removido;
                removido = hash_remove(&th, &t->escritas[t->topo_e]->x, &erro, Desenha);
                nome = (char*) malloc(sizeof(t->escritas[t->topo_e]->x));
                strcpy(nome, t->escritas[t->topo_e]->x);
                t->escritas[t->topo_e--] = NULL;
                if(!erro){
                    tela_remove_musica(&t, nome);
                    mode = INICIO;
                }else{
                    erroflag = ERRO_REMOVER;
                    setPointf(t->underscore, 92.0f, 622.0f);
                }
                escreveu = 0;
                keys[KEY_1] = 0;
            }else if(keys[KEY_2]){
                mode = INICIO;
                keys[KEY_2] = 0;
                if(escreveu)
                    t->escritas[t->topo_e--] = NULL;
                escreveu = 0;
            }
            break;
        case BUSCA:
            if(keys[KEY_1] || enter){
                    enter = 0;
                    int erro, hash;
                    hash = hash_busca(&th, &t->escritas[t->topo_e]->x, &erro, Desenha);
                    h.mcores[hash] = Cores[3];
                    h.pcores[hash] = Cores[3];
                    destaque = hash;
                    t->escritas[t->topo_e--] = NULL;
                mode = INICIO;
                keys[KEY_1] = 0;
                escreveu = 0;
            }else if(keys[KEY_2]){
                mode = INICIO;
                keys[KEY_2] = 0;
                if(escreveu)
                    t->escritas[t->topo_e--] = NULL;
                escreveu = 0;
            }
            break;
    }
    if(mode == REMOVE || mode == BUSCA){
        if(letra > 0){
            escrita *e;
            char *fletra;
            if(!escreveu){
                fletra = (char*) malloc(sizeof(char)*4);
                char temp[2] = {(char)letra, '\0'};
                strcpy(fletra, temp);
                escrita_cria(&e, fletra, 92 , 624);
                tela_add_escrita(&t, e);
                escreveu = 1;
            }else{
                char temp[2] = {(char)letra, '\0'};
                strcat(t->escritas[t->topo_e]->x, temp);
            }
            t->underscore->xi += 2;
            t->underscore->xf += 2.3f;
            letra = 0;
        }else if(letra < 0){
            int length = strlen(t->escritas[t->topo_e]->x);
            if(escreveu && length > 0){
                char temp[length-1];
                strncpy(temp, t->escritas[t->topo_e]->x, length-1);
                temp[length-1] = '\0';
                strcpy(t->escritas[t->topo_e]->x, temp);
                t->underscore->xi -= 2;
                t->underscore->xf -= 2.3f;
            }
            letra = 0;
        }
    }
    Desenha();
}

void Idle(){
}

void Timer(int id){
    glutTimerFunc(1000, Timer, 100);
    if(mode != INICIO)
        uver = uver>=1?0:uver+1;
    if(destaque > 0){
        if(destaque > 300){
            destaque = destaque%100;
            h.mcores[destaque] = Cores[1];
            h.pcores[destaque] = Cores[1];
            destaque = -1;
        }else{
            destaque += 100;
        }
    }
    Update();
}

void Desenha(){
    int i;
     glMatrixMode(GL_MODELVIEW);
     glLoadIdentity();

     // Limpa a janela de visualização com a cor de fundo especificada
     glClear(GL_COLOR_BUFFER_BIT);

    //Desenha o Titulo da Aplicação
    DesenhaTitulo();
    DesenhaMenu();

    switch(mode){
        case INICIO:
            break;
        case ADICIONA:
        case REMOVE:
        case BUSCA:
            if(uver % 2 == 0){
                DesenhaUnderscore(t->underscore);
            }
            break;
    }
    for(i = 0; i <= t->topo_b; i++){
        if(t->boxes[i] != NULL)
            DesenhaBox(t->boxes[i]);
    }
    for(i = 0; i <= t->topo_e; i++){
        if(t->escritas[i] != NULL)
            DesenhaEscrita(t->escritas[i]);
    }

    if(erroflag!=-1){
        switch(erroflag){
            case ERRO_ADICIONAR:
                Escreve(erromsg[ERRO_ADICIONAR], Cores[0], 165, 620, GLUT_BITMAP_HELVETICA_18);
                break;
            case ERRO_REMOVER:
                Escreve(erromsg[ERRO_REMOVER], Cores[0], 165, 620, GLUT_BITMAP_HELVETICA_18);
                break;
            case ERRO_BUSCAR:
                Escreve(erromsg[ERRO_BUSCAR], Cores[0], 165, 620, GLUT_BITMAP_HELVETICA_18);
                break;
        }
    }

    DesenhaTabela();

    //Cor Branca padrão
     glColor3f(1.0f, 1.0f, 1.0f);

     glFlush();
}

void Keyboard(unsigned char key, int x, int y){
    int ikey = (int) key; //Tranforma o char da tecla em inteiro
    if(keypress){
        keys[ikey] = 1;
        if(ikey >= 65 && ikey <= 122 || ikey == 32)
            letra = ikey;
        if(ikey == 8)
            letra = -1;
        if(ikey == 13)
            enter = 1;
    }
    Update();
}

void KeyboardUp(unsigned char key, int x, int y){
    int ikey = (int) key; //Tranforma o char da tecla em inteiro
    if(keypress){
        keys[ikey] = 0;
    }
}

void SpecialKeys(int key, int x, int y){

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
        gluOrtho2D(0.0f, 700.0f, 0.0f, 700.0f * h/w);
    else
        gluOrtho2D(0.0f, 700.0f * h/w, 0.0f, 700.0f);
}

void DesenhaTitulo(){
    char *titulo;
    titulo = "Tabela Hash";
    Escreve(titulo, Cores[1], 150.0f, 680.0f, GLUT_BITMAP_TIMES_ROMAN_24);
}

void DesenhaMenu(){
    switch(mode){
        case INICIO:
            Escreve("1 - Adicionar Musica", Cores[0], 10.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            Escreve("2 - Remover Musica", Cores[0], 60.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            Escreve("3 - Buscar Musica", Cores[0], 110.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            break;
        case ADICIONA:
            Escreve("1/Enter - Confirma", Cores[0], 10.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            Escreve("2 - Cancela", Cores[0], 60.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            break;
        case REMOVE:
        case BUSCA:
            Escreve("1/Enter - Confirma", Cores[0], 10.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            Escreve("2 - Cancela", Cores[0], 60.0f, 660.0f, GLUT_BITMAP_HELVETICA_18);
            if(mode == REMOVE)
                Escreve("Digite o nome da musica a ser removida: ", Cores[0], 10.0f, 625.0f, GLUT_BITMAP_HELVETICA_18);
            else
                Escreve("Digite o nome da musica a ser buscada: ", Cores[0], 10.0f, 625.0f, GLUT_BITMAP_HELVETICA_18);
            box *b;
            box_cria(&b, 90, 620, 72, 18, 1.0f, 1.0f, 1.0f);
            DesenhaBox(b);
            break;
    }
}

void DesenhaTabela(){
    int i;
    float width = 50.0f, height = 18.0f, y = 550.0f, x = 300.0f;
    glLineWidth(1.0f);
    for(i = 0; i < 30; i++){
        glColor3f(h.mcores[i].rf, h.mcores[i].gf, h.mcores[i].bf);
        glBegin(GL_LINE_LOOP);
            glVertex2f(x, y - i*height);
            glVertex2f(x + width, y - i*height);
            glVertex2f(x + width, y - height - i*height);
            glVertex2f(x, y - height - i*height);
        glEnd();
        glColor3f(h.pcores[i].rf, h.pcores[i].gf, h.pcores[i].bf);
        glBegin(GL_LINE_LOOP);
            glVertex2f(x + width, y - i*height);
            glVertex2f(x + width + 10.0f, y - i*height);
            glVertex2f(x + width + 10.0f, y - height - i*height);
            glVertex2f(x + width, y - height - i*height);
        glEnd();
        if(th->temp[i]->nome != NULL){
            Escreve(th->temp[i]->nome, Cores[1], x + 2.0f, y - i*height - height + 5.0f, GLUT_BITMAP_HELVETICA_12);
        }
        if(th->temp[i]->prox != -1){
            char *c;
            c = (char*) malloc(sizeof(char)*3);
            itoa(th->temp[i]->prox, c, 10);
            Escreve(c, Cores[1], x + width + 2.0f, y - i*height - height + 4.0f, GLUT_BITMAP_HELVETICA_18);
        }else{
            Escreve("-1", Cores[1], x + width + 2.0f, y - i*height - height + 4.0f, GLUT_BITMAP_HELVETICA_18);
        }
    }
}
