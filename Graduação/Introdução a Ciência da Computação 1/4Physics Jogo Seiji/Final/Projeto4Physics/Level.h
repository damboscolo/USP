
/*
*   Classe Level
*   Atributos:
*       - SDL_Rect box : Tamanho da Fase
*       - int **mapa : matriz as posicoes dos elementos da fase
*       - int linhas e colunas: guarda o numero de linhas e colunas de tiles tem no mapa
*       - int nTiles: conta o numero de tiles usados no level, sem contar os 0
*       - Tile mapTiles: vetor de referencia a tiles no mapa
*/
class Level{

    private:
    SDL_Rect box;

    int **mapa, linhas, colunas, nTiles, width, height, portalId, level;
    Tile **mapTiles;
    Personagem *p;

    public:
    bool ok;
    Level(int level, Personagem *per);

    //Carrega a matriz de mapa com as informaçoes de um arquivo
    bool load_mapa();

    void desenha();
    void criaTiles();
    void update();
    Tile** getTiles();
    int getNTiles(){
        return nTiles;
    }
    void set_camera();
    bool levelFim();
    int getNextLevel(){
        return level+1;
    }
};

Level::Level(int l, Personagem *per){
    box.x = 0;
    box.y = 0;
    box.w = 1280;
    box.h = 720;
    level = l;
    p = per;
    if(load_mapa())
        criaTiles();
}

bool Level::load_mapa(){
    stringstream ss (stringstream::in | stringstream::out);
    ss << "mapas/" << level << ".txt";
    FILE *mapaFile = fopen(ss.str().c_str(), "r");
    if(mapaFile == NULL)
        return false;

    int **mapaTmp, lin, col, i, j;

    //Pega o numero de linhas e colunas da fase contidos no arquivo dela
    fscanf(mapaFile, "%d %d %d %d", &lin, &col, &width, &height);

    linhas = lin;
    colunas = col;

    //Aloca uma matriz do tamanho do mapa
    mapaTmp = (int **) calloc(lin, sizeof(int *));
    for(i = 0; i < lin; i++){
        mapaTmp[i] = (int *) calloc(col, sizeof(int));
    }

    //Coloca os dados do arquivo dentro da matriz mapa
    for(i = 0; i < lin; i++){
        fscanf(mapaFile, "\n");
        for(j = 0; j < col; j++){
            fscanf(mapaFile, "%d ", &mapaTmp[i][j]);
        }
    }

    //Coloca a matriz criada por essa funçao no atributo mapa do Level
    mapa = mapaTmp;
    return true;
}

void Level::criaTiles(){
    int i,j, count = 0;
    Tile **tmpMapTiles;
    for(i = 0; i < linhas; i++){
        for(j = 0; j < colunas; j++){
            if(mapa[i][j] != 0){
                count++;
                if(count > 1){
                    tmpMapTiles = (Tile**) realloc(mapTiles, sizeof(Tile*) * count);
                    if(tmpMapTiles != NULL)
                        mapTiles = tmpMapTiles;
                    else
                        free(mapTiles);
                }else
                    mapTiles = (Tile**) calloc(count, sizeof(Tile**));
                switch(mapa[i][j]){
                    case 1:
                        mapTiles[count-1] = new BlocoBasico(p, j*40, i*40, 40, 40, mapa[i][j], count-1);
                        break;
                    case 2:
                        mapTiles[count-1] = new BlocoGravidade(p, j*40, i*40, 40, 40, mapa[i][j], count-1, LEFT);
                        break;
                    case 3:
                        mapTiles[count-1] = new BlocoGravidade(p, j*40, i*40, 40, 40, mapa[i][j], count-1, RIGHT);
                        break;
                    case 4:
                        mapTiles[count-1] = new BlocoGravidade(p, j*40, i*40, 40, 40, mapa[i][j], count-1, UP);
                        break;
                    case 5:
                        mapTiles[count-1] = new BlocoGravidade(p, j*40, i*40, 40, 40, mapa[i][j], count-1, DOWN);
                        break;
                    case 6:
                        mapTiles[count-1] = new Portal(p, j*40, i*40 - 40, 80, 80, mapa[i][j], count-1);
                        portalId = count-1;
                        break;
                }
            }
        }
    }
    nTiles = count;
}

void Level::desenha(){
    int i;
    for(i = 0; i < nTiles; i++){
        mapTiles[i]->draw();
    }
}

Tile** Level::getTiles(){
    return mapTiles;
}

void Level::update(){
    int i;
    set_camera();
    for(i = 0; i < nTiles; i++){
        mapTiles[i]->update();
    }
}

void Level::set_camera(){

    SDL_Rect box = p->getDimensions();

    //Faz a camera acompanhar o personagem
    camera.x = ( box.x + PERSON_WIDTH / 2 ) - SCREEN_WIDTH / 2;
    camera.y = ( box.y + PERSON_HEIGHT / 2 ) - SCREEN_HEIGHT / 2;

    //Mantem a camera dentro da tela
    camera.x = camera.x < 0?0:camera.x;
    camera.y = camera.y < 0?0:camera.y;
    camera.x = camera.x > width - camera.w?width - camera.w:camera.x;
    camera.y = camera.y > height - camera.h?height - camera.h:camera.y;
}

bool Level::levelFim(){
    return mapTiles[portalId]->getAtivo();
}
