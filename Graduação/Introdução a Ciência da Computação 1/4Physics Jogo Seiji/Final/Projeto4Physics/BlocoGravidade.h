class BlocoGravidade: public Tile{
    private:
        int orientacao[2], modo, delay, frame;
        bool colidiu;
        SDL_Rect sprite[2][6];

    public:
    BlocoGravidade(Personagem *per, int x, int y, int w, int h, int identifier, int tileId, int ori);
    ~BlocoGravidade();
    void draw();
    void colision_event();
    void update();
};

BlocoGravidade::BlocoGravidade(Personagem *per, int x, int y, int w, int h, int identifier, int tileId, int ori):Tile(per, x, y, w, h, identifier, tileId){
    colide = true;
    colidiu = false;
    has_update = true;
    has_colision_event = true;
    ativo = false;
    colidindo = false;
    orientacao[0] = per->getOri();
    orientacao[1] = ori;
    frame = 0; // Começa com o a animaçao do personagem no frame 0
    delay = 0;
    for(int i = 0; i < 2; i++){
        for(int j = 0; j < 6; j++){
            sprite[i][j].x = 40 * j;
            sprite[i][j].y = (40 * i * 2) + (40 * orientacao[1] * (i+1));
            sprite[i][j].w = 40;
            sprite[i][j].h = 40;
        }
    }
    modo = 0;
};

BlocoGravidade::~BlocoGravidade(){
    SDL_FreeSurface(tileImage);
}

void BlocoGravidade::draw(){
    frame = frame<5?frame+1:0;
    apply_surface( box.x - camera.x, box.y - camera.y, tiles[id], screen, &sprite[modo][frame]);
    modo = 0;
}

void BlocoGravidade::update(){
    if(colidiu == true){
        delay = delay<5?delay+1:0;
        if(delay == 4)
            colidiu = false;
    }

}

void BlocoGravidade::colision_event(){
    modo = colidiu==true?1:0;
    if(colidindo == false){
        colidiu = true;
        p->setOri(ativo==true?orientacao[0]:orientacao[1]);
        ativo = ativo == true?false:true;
        colidindo = true;
    }
}

