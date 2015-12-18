class Portal: public Tile{
    private:
        int frame;
        SDL_Rect sprite[11];

    public:
    Portal(Personagem *per, int x, int y, int w, int h, int identifier, int tileId);
    ~Portal();
    void draw();
    void colision_event();
    void update();
};

Portal::Portal(Personagem *per, int x, int y, int w, int h, int identifier, int tileId):Tile(per, x, y, w, h, identifier, tileId){
    colide = false;
    has_update = true;
    has_colision_event = true;
    ativo = false;
    colidindo = false;
    frame = 0; // Começa com o a animaçao do personagem no frame 0
    for(int i = 0; i < 11; i++){
        sprite[i].x = 80 * i;
        sprite[i].y = 0;
        sprite[i].w = 80;
        sprite[i].h = 80;
    }
};

Portal::~Portal(){
    SDL_FreeSurface(tileImage);
}

void Portal::draw(){
    apply_surface( box.x - camera.x, box.y - camera.y, tiles[id], screen, &sprite[frame]);
}

void Portal::update(){
    if(colidindo == false && frame > 0)
        frame--;
    if(colidindo == true)
        colidindo = false;
}

void Portal::colision_event(){
    frame = frame<10?frame+1:10;
    colidindo = true;
    if(frame == 10){
        ativo = true;
    }
}


