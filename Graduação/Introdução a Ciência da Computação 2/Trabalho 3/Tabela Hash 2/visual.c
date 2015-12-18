#include "visual.h"

void Escreve(char *texto, Cor c, float x, float y, int fonte){
    int i;
    //Muda a cor do Texto
    //glColor3f(c.rf, c.gf, c.bf);
    i = 0;
    glPushMatrix();
    glRasterPos2f(x, y); //Reposiciona a posicao do opengl para desenhar a letra no lugar certo
    if(texto != NULL){
        for(i = 0; i < strlen(texto); i++){//Desenha todos os char do valor
        //while(texto[i] != '\0'){
            glutBitmapCharacter(fonte , texto[i]);
            //i++;
        }
    }
}

void criaCori(Cor *c, int r, int g, int b){
    c->ri = r;
    c->gi = g;
    c->bi = b;
    c->rf = (float) r;
    c->gf = (float) g;
    c->bf = (float) b;
}

void criaCorf(Cor *c, float r, float g, float b){
    c->ri = (int) r;
    c->gi = (int) g;
    c->bi = (int) b;
    c->rf = r;
    c->gf = g;
    c->bf = b;

}

int* getCoresi(Cor *c){
    int v[3];
    v[0] = c->ri;
    v[1] = c->gi;
    v[2] = c->bi;
    return v;
}

float* getCoresf(Cor *c){
    float v[3];
    v[0] = c->rf;
    v[1] = c->gf;
    v[2] = c->bf;
    return v;
}

void criaListaCores(lista_cores *lc){
    lc->topo = 0;
}

void lista_cores_adiciona_cor(lista_cores *lc, Cor *c){
    lc->c[lc->topo] = c;
    lc->topo++;
}

void setPointi(point *p, int x, int y){
    p->xi = x;
    p->yi = y;
    p->xf = (float) x;
    p->yf = (float) y;
}

void setPointf(point *p, float x, float y){
    p->xi = (int) x;
    p->yi = (int) y;
    p->xf = x;
    p->yf = y;
}

int* getPointi(point *p){
    int v[2];
    v[0] = p->xi;
    v[1] = p->yi;
    return v;
}

float* getPointf(point *p){
    float v[2];
    v[0] = p->xf;
    v[1] = p->yf;
    return v;
}

void setAreai(area *a, int x, int y, int width, int height){
    a->xi = x;
    a->yi = y;
    a->widthi = width;
    a->heighti = height;
    a->xf = (float) x;
    a->yf = (float) y;
    a->widthf = (float) width;
    a->heightf = (float) height;
}

void setAreaf(area *a, float x, float y, float width, float height){
    a->xi = (int) x;
    a->yi = (int) y;
    a->widthi = (int) width;
    a->heighti = (int) height;
    a->xf = x;
    a->yf = y;
    a->widthf = width;
    a->heightf = height;
}

int* getAreai(area *a){
    int v[4];
    v[0] = a->xi;
    v[1] = a->yi;
    v[2] = a->widthi;
    v[3] = a->heighti;
    return v;
}


float* getAreaf(area *a){
    float v[4];
    v[0] = a->xf;
    v[1] = a->yf;
    v[2] = a->widthf;
    v[3] = a->heightf;
    return v;
}

void anima_elemento(int pos, point coord, int tempo, elemento *e){
    int sleep;
    float dist, coordx, coordy;
    e->movendo = 1; //Marca que o bloco esta se movendo portanto sua posicao nao precisa ser recalculada pelo reposiciona_elementos();
    switch(pos){
        case POS_X:
            sleep = tempo / (coord.xi<0?-coord.xi:coord.xi); // Calcula o tempo entre cada incremento
            while(coord.xi != 0){
                if(coord.xi > 0){
                    e->x = e->x - 1;
                    coord.xi--;
                }else{
                    e->x = e->x + 1;
                    coord.xi++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
        case POS_Y:
            sleep = tempo / (coord.yi<0?-coord.yi:coord.yi); // Calcula o tempo entre cada incremento
            while(coord.yi != 0){
                if(coord.yi > 0){
                    e->y = e->y - 1;
                    coord.yi--;
                }else{
                    e->y = e->y + 1;
                    coord.yi++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
        case POS_BOTH:
            coordx = coord.xi<0?-coord.xi:coord.xi;
            coordy = coord.yi<0?-coord.yi:coord.yi;
            dist = coordx > coordy ? coordx : coordy; //Calcula a distancia entre o elemento e a posicao desejada
            sleep = tempo / dist; // Calcula o tempo entre cada incremento
            while(coord.xi != 0 || coord.yi != 0){
                if(coord.xi > 0){
                    e->x = e->x - 1;
                    coord.xi--;
                }else if(coord.xi < 0){
                    e->x = e->x + 1;
                    coord.xi++;
                }
                if(coord.yi > 0){
                    e->y = e->y - 1;
                    coord.yi--;
                }else if(coord.yi < 0){
                    e->y = e->y + 1;
                    coord.yi++;
                }
                Sleep(sleep);
                Desenha();
            }
            break;
    }
    e->movendo = 0; //Marca o elemento para ser reposicionado no lugar correto novamente assim que a animação acaba
}
void square(area *a){

}
void legenda(char** textos, lista_cores *lc, point init){

}
