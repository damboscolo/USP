#include "hash.h"

void escrita_cria(escrita **e, char *texto, int x, int y){
    *e = (escrita*) malloc(sizeof(escrita));
    (*e)->coord = (point*) malloc(sizeof(point));
    (*e)->x = (char*) malloc(sizeof(texto));
    setPointi((*e)->coord, x, y);
    strcpy((*e)->x, texto);
}
void box_cria(box **b, int x, int y, int width, int height, float cr, float cg, float cb){
    *b = (box*) malloc(sizeof(box));
    (*b)->cor = (Cor*) malloc(sizeof(Cor));
    (*b)->a = (area*) malloc(sizeof(area));
    setAreai((*b)->a, x, y, width, height);
    criaCorf((*b)->cor, cr, cg, cb);
}
void seta_cria(seta **s, int tipo, int ix, int iy, int fx, int fy, int *tamanhos, float cr, float cg, float cb){
    *s = (seta*) malloc(sizeof(seta));
    (*s)->cor = (Cor*) malloc(sizeof(Cor));
    (*s)->inicio = (point*) malloc(sizeof(point));
    (*s)->fim = (point*) malloc(sizeof(point));
    setPointi((*s)->inicio, ix, iy);
    setPointi((*s)->fim, fx, fy);
    criaCorf((*s)->cor, cr, cg, cb);
    (*s)->tamanhos = tamanhos;
    (*s)->tipo = tipo;
}

void tela_add_escrita(tela **t, escrita *e){
    (*t)->escritas[++(*t)->topo_e] = e;
}
void tela_add_box(tela **t, box *b){
    (*t)->boxes[++(*t)->topo_b] = b;
}
void tela_add_seta(tela **t, seta *s){
    (*t)->setas[++(*t)->topo_s] = s;
}

void tela_remove_musica(tela **t, hashinfo *x){
    int i = 0, boxi = 0;
    point *antp;
    area *anta;
    while((*t)->escritas[i] != NULL){
        if(!strcmp((*t)->escritas[i]->x, x)){
            int j = i;
            boxi = i;
            while((*t)->escritas[j+1]!=NULL){
                setPointf((*t)->escritas[j+1]->coord, 11.0f + j*57.0f, 584.0f);
                (*t)->escritas[j] = (*t)->escritas[j+1];
                j++;
            }
            (*t)->escritas[j] = NULL;
            (*t)->topo_e--;
        }
        i++;
    }
    while((*t)->boxes[boxi+1]!=NULL){
        setAreaf((*t)->boxes[boxi+1]->a, 9.0f + boxi*57.0f, 579.0f, 52.0f, 18.0f);
        (*t)->boxes[boxi] = (*t)->boxes[boxi+1];
        boxi++;
    }
    (*t)->boxes[boxi] = NULL;
    (*t)->topo_b--;
}

void DesenhaBox(box *b){
    Cor *cor = b->cor;
    area *a = b->a;
    glLineWidth(2.0f);
    glColor3f(b->cor->rf, b->cor->gf, b->cor->bf);
    glBegin(GL_LINE_LOOP);
        glVertex2i(a->xi, a->yi);
        glVertex2i(a->xi + a->widthi, a->yi);
        glVertex2i(a->xi + a->widthi, a->yi + a->heighti);
        glVertex2i(a->xi, a->yi + a->heighti);
    glEnd();
}

void DesenhaEscrita(escrita *e){
    Cor cor;
    criaCorf(&cor, 1.0f, 1.0f, 1.0f);//Branco
    Escreve(e->x, cor, e->coord->xf, e->coord->yf, GLUT_BITMAP_HELVETICA_18);
}

void DesenhaSeta(seta*);

void DesenhaUnderscore(point *p){
    glLineWidth(2.0f);
    glColor3f(1.0f, 1.0f, 1.0f);
    glBegin(GL_LINES);
        glVertex2f(p->xf, p->yf);
        glVertex2f(p->xf+3.0f, p->yf);
    glEnd();
}

void Delay(int time, void (*f)()){
    Sleep(time);
    (*f)();
}

int hash_hashinterno(char *x){
    int primeira;
    primeira = ((int) toupper(x[0])) - 65;
    return primeira % HTAM;
}

void hash_insere(tabelahash **th, hashinfo **x, int *erro, void (*f)()){
    int hash, ant;
    char *nome = *x;
    musica *m, *aux, *temp, *tant;
    hash = hash_hashinterno((*x));
    m = (*th)->musicas[hash];
    if(m->prox == -1 && m->nome == NULL){
        m->nome = (char*) malloc(sizeof(nome));
        (*th)->temp[hash]->nome = (char*) malloc(sizeof(nome));
        strcpy(m->nome, nome);
        strcpy((*th)->temp[hash]->nome, nome);
        m->prox = -1;
    }else{
        ant = hash;
        tant = (*th)->temp[hash];
        while(m->prox != -1){
            ant = m->prox;
            tant = (*th)->temp[m->prox];
            m = (*th)->musicas[m->prox];
        }
        tant->prox = (*th)->vazio;
        m->prox = (*th)->vazio++;
        temp = (*th)->temp[m->prox];
        aux = (*th)->musicas[m->prox];
        aux->nome = (char*) malloc(sizeof(nome));
        temp->nome = (char*) malloc(sizeof(nome));
        strcpy(aux->nome, nome);
        strcpy(temp->nome, nome);
    }
}

int hash_remove(tabelahash **th, hashinfo **x, int *erro, void (*f)()){
    int hash, temp, prox;
    char *nome = *x;
    musica *m, *aux, *tant, *ant;
    hash = hash_hashinterno(nome);
    temp = hash_busca(th, x, erro, f);
    if(temp == -1){
        *erro = 1;
        return -1;
    }
    m = (*th)->musicas[temp];
    tant = (*th)->temp[temp];
    if(m->prox != -1){
        ant = m;
        while(m->prox != -1){
            prox = m->prox;
            ant = m;
            tant->nome = (*th)->temp[prox]->nome;
            //tant->prox = (*th)->temp[prox]->prox;
            m->nome = (*th)->musicas[prox]->nome;
            //m->prox = (*th)->musicas[prox]->prox;
            if(prox != -1){
                m = (*th)->musicas[prox];
                tant = (*th)->temp[prox];
            }
        }
        (*th)->temp[prox]->nome = NULL;
        (*th)->temp[prox]->prox = -1;
        (*th)->musicas[prox]->nome = NULL;
        (*th)->musicas[prox]->prox = -1;
    }else{
        musica *p, *ptemp;
        p = (*th)->musicas[hash];
        ptemp = (*th)->temp[hash];
        while(p->prox != temp){
            p = (*th)->musicas[p->prox];
            ptemp = (*th)->temp[p->prox];
        }
        p->prox = -1;
        ptemp->prox = -1;
        m->nome = NULL;
        m->prox = -1;
        tant->nome = NULL;
        tant->prox = -1;
    }
    return temp;
}

int hash_busca(tabelahash **th, hashinfo **x, int *erro, void (*f)()){
    int hash, temp;
    char *nome = *x;
    musica *m, *aux;
    hash = hash_hashinterno(nome);
    m = (*th)->musicas[hash];
    temp = hash;
    if(m->nome == NULL)
        return -1;
    if(!strcmp(m->nome, nome)){
        return temp;
    }else{
        temp = m->prox;
        while(m->prox != -1){
            if(!strcmp((*th)->musicas[m->prox]->nome, nome)){
                return temp;
            }
            m = (*th)->musicas[m->prox];
        }
    }
    return -1;
}
