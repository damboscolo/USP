class BlocoBasico: public Tile{
    public:
    BlocoBasico(Personagem *per, int x, int y, int w, int h, int identifier, int tileId);
    ~BlocoBasico();
    void draw();
    void colision_event();
    void update();
};

BlocoBasico::BlocoBasico(Personagem *per, int x, int y, int w, int h, int identifier, int tileId):Tile(per, x, y, w, h, identifier, tileId){
    colide = true;
    has_update = false;
    has_colision_event = false;
};

BlocoBasico::~BlocoBasico(){
    SDL_FreeSurface(tileImage);
}

void BlocoBasico::draw(){
    apply_surface( box.x - camera.x, box.y - camera.y, tiles[id], screen );
}

void BlocoBasico::update(){}
void BlocoBasico::colision_event(){}

