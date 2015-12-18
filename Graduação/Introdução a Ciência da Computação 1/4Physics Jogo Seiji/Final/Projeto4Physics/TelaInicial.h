class TelaInicial : public GameState{
    private:
    SDL_Surface *logo;
    SDL_Surface *novoJogo;
    SDL_Surface *score;
    SDL_Surface *creditos;
    SDL_Surface *sair;
    SDL_Surface *seta;
    SDL_Surface *beta;

    int setaPos[2][4], op, delay;

    public:
    TelaInicial();
    ~TelaInicial();

    //Main loop functions
    void events();
    void logica();
    void render();

};

TelaInicial::TelaInicial(){
    logo = load_image("imagens/logoJogo.png");
    novoJogo = load_image("imagens/novoJogo.png");
    score = load_image("imagens/score.png");
    creditos = load_image("imagens/creditos.png");
    sair = load_image("imagens/sair.png");
    seta = load_image("imagens/seta.png");
    beta = load_image("imagens/beta.png");
    op = 0;
    setaPos[0][0] = 410;
    setaPos[0][1] = 500;
    setaPos[0][2] = 470;
    setaPos[0][3] = 520;
    setaPos[1][0] = 375;
    setaPos[1][1] = 455;
    setaPos[1][2] = 525;
    setaPos[1][3] = 600;
    delay = 0;
}

TelaInicial::~TelaInicial(){
    SDL_FreeSurface(logo);
    SDL_FreeSurface(novoJogo);
    SDL_FreeSurface(score);
    SDL_FreeSurface(creditos);
    SDL_FreeSurface(sair);
    SDL_FreeSurface(seta);
    SDL_FreeSurface(beta);
}


void TelaInicial::events(){
    //While there's events to handle
    while( SDL_PollEvent( &event ) ){

        if(event.type == SDL_KEYDOWN){
            keys[event.key.keysym.sym] = true;
            switch(event.key.keysym.sym){
                case SDLK_UP:
                    op = op>0?op-1:3;
                    delay = 1;
                    break;
                case SDLK_DOWN:
                    op = op<3?op+1:0;
                    delay = 1;
                    break;
            }
        }
        if(event.type == SDL_KEYUP){
            keys[event.key.keysym.sym] = false;
            delay = 1;
        }

        //If the user has Xed out the window
        if( event.type == SDL_QUIT ){
            //Quit the program
            set_next_state( STATE_EXIT );
        }
    }
}

void TelaInicial::logica(){
    if(delay == 0){
        if(keys[SDLK_UP])
            op = op>0?op-1:3;
        if(keys[SDLK_DOWN])
            op = op<3?op+1:0;
    }
    delay = delay<5?delay+1:0;
    if(keys[SDLK_RETURN]){
        switch(op){
            case 0:
                nextState = STATE_JOGO;
                break;
            case 1:
                nextState = STATE_HIGHSCORE;
                break;
            case 2:
                nextState = STATE_CREDITOS;
                break;
            case 3:
                nextState = STATE_EXIT;
                break;
        }
    }
}

void TelaInicial::render(){
    //Fill the screen white
    SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
    apply_surface( 200, 50, logo, screen);
    apply_surface( 470, 360, novoJogo, screen);
    apply_surface( 560, 450, score, screen);
    apply_surface( 530, 525, creditos, screen);
    apply_surface( 580, 600, sair, screen);
    apply_surface( setaPos[0][op], setaPos[1][op], seta, screen);
    apply_surface( 1180, 660, beta, screen);

}
