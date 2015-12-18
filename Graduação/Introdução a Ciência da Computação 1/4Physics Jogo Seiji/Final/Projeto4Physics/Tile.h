
/*
*   Classe dos Tiles que compoem a fase (basicamente tudo menos os personagem e o background)
*   Atributos:
*       - SDL_Rect box: Tamanho do tile
*       - SDL_Surface tileImage: imagem usada pelo tile
*       - int id: id a ser relacionado com o mapeamento do level
*       - int position: posicao de profundidade na tela, casa possa passar pelo tile onde fica o tile quando passa. Ex: FRONT, BACK
*       - int tile_id: id do tile em relacao ao conjunto de SDL_Surfaces, para poder usar freeSurface quando destruido
*       - bool colide: verifica se o tile bloqueia o usuario ou pode se passar por ele.
*       - bool has_update: verifica se o tile possui funçao de update de valores ou movimento
*       - bool has_colision_event: verifica se o tile possui um evento ao colidirem com ele
*/
class Tile{

    protected:

    SDL_Rect box;
    SDL_Surface *tileImage;
    int id, position, tile_id;
    bool colide, has_update, has_colision_event, colidindo, ativo;
    Personagem *p;

    public:

    Tile(Personagem *per, int x, int y, int w, int h, int identifier, int tileId);

    virtual ~Tile();
    virtual void colision_event() = 0;
    virtual void update() = 0;
    virtual void draw();
    bool getAtivo(){
        return ativo;
    }
    SDL_Rect getDimensions();

    bool hasUpdate(){
        return has_update;
    }

    bool hasColisionEvent(){
        return has_colision_event;
    }

    bool getColide(){
        return colide;
    }

    void setColidindo(bool c){
        colidindo = c;
    }
};

Tile::Tile(Personagem *per, int x, int y, int w, int h, int identifier, int tileId){
    box.x = x;
    box.y = y;
    box.w = w;
    box.h = h;
    id = identifier;
    tile_id = tileId;
    p = per;
}

void Tile::draw(){
    apply_surface( box.x - camera.x, box.y - camera.y, tiles[id], screen );
}

Tile::~Tile(){}

SDL_Rect Tile::getDimensions(){
    return box;
}

