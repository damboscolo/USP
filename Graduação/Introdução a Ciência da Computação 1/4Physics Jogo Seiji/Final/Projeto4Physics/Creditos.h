class Creditos : public GameState{
    private:
    SDL_Surface *seta;
    SDL_Surface *voltar;
    SDL_Surface *credito;

    public:
    Creditos();
    ~Creditos();

    //Main loop functions
    void events();
    void logica();
    void render();

};

Creditos::Creditos(){
    seta = load_image("imagens/seta.png");
    voltar = load_image("imagens/voltar.png");
    credito = load_image("imagens/credito.png");
}

Creditos::~Creditos(){
    SDL_FreeSurface(seta);
    SDL_FreeSurface(voltar);
    SDL_FreeSurface(credito);
}


void Creditos::events(){
    //While there's events to handle
    while( SDL_PollEvent( &event ) ){

        if(event.type == SDL_KEYDOWN){
            keys[event.key.keysym.sym] = true;
        }
        if(event.type == SDL_KEYUP){
            keys[event.key.keysym.sym] = false;
        }

        //If the user has Xed out the window
        if( event.type == SDL_QUIT ){
            //Quit the program
            set_next_state( STATE_EXIT );
        }
    }
}

void Creditos::logica(){
    if(keys[SDLK_RETURN]){
        nextState = STATE_INICIAL;
    }
}

void Creditos::render(){
    //Fill the screen white
    SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
    apply_surface( 0, 0, credito, screen);
    apply_surface( SCREEN_WIDTH - 250, SCREEN_HEIGHT - 70, seta, screen);
    apply_surface( SCREEN_WIDTH - 180, SCREEN_HEIGHT - 70, voltar, screen);

}
