bool colisao_personagem_objeto(Personagem *per, SDL_Rect t, bool colidira);

class Jogo : public GameState{
    private:
    Personagem personagem;
    Level *currentLevel;
    Timer myTimer;
    SDL_Surface *fundopausa;
    SDL_Surface *setapausa;
    SDL_Surface *fundo;
    FILE *testeLevel;

    SDL_Surface *seconds;
    bool running, pausado;
    int setaPos[3], op, delay,alpha;


    public:
    Jogo();
    ~Jogo();

    //Main loop functions
    void checkColision();
    void events();
    void logica();
    void render();

};

Jogo::Jogo(){
    personagemS = load_image( "imagens/personagem.png" );
    background = load_image("imagens/background.png");
    fundopausa = load_image("imagens/fundopause.fw.png");
    fundo = load_image("imagens/fundo.png");
    setapausa = load_image("imagens/seta.png");
    criaTiles();
    currentLevel = new Level(INTRO, &personagem);
    alpha = SDL_ALPHA_TRANSPARENT + 10;

    pausado = false;
    running = true;

    //posicoes da seta para o menu de pausa
    op = 0;
    seconds = 0;
    setaPos[0]= 212;
    setaPos[1] = 316;
    setaPos[2] = 412;
    delay = 0;
    myTimer.start();
}

Jogo::~Jogo(){
    SDL_FreeSurface(personagemS);
    SDL_FreeSurface(fundo);
    SDL_FreeSurface(fundopausa);
    SDL_FreeSurface(setapausa);
    SDL_FreeSurface(seconds);
}

void Jogo::checkColision(){
    int i, tilesN = currentLevel->getNTiles();
    Tile** mapTiles = currentLevel->getTiles();
    SDL_Rect p = personagem.getDimensions();
    SDL_Rect t;
    personagem.resetColide();
    for(i = 0; i < tilesN; i++){
        t = mapTiles[i]->getDimensions();
        if(colisao_personagem_objeto(&personagem, t, mapTiles[i]->getColide()) == true){
            if(mapTiles[i]->hasColisionEvent())
                mapTiles[i]->colision_event();
        }else{
            mapTiles[i]->setColidindo(false);
        }
    }
}

void Jogo::events(){
    //While there's events to handle
    while( SDL_PollEvent( &event ) ){

        if (pausado == false) {
            personagem.handle_input();
        }

        if(event.type == SDL_KEYDOWN)
        {
            keys[event.key.keysym.sym] = true;
            if(event.key.keysym.sym==SDLK_p || event.key.keysym.sym == SDLK_ESCAPE)
            {
                if( !myTimer.is_paused())
                {
                    //Stop the timer
                    myTimer.pause();
                }
                else
                {
                    myTimer.unpause();
                }
                pausado = !pausado;

            }
            if(pausado == true)
            {
                //If the timer is running
                switch(event.key.keysym.sym)
                {
                    case SDLK_UP:
                        op = op>0?op-1:2;
                        delay = 1;
                        break;
                    case SDLK_DOWN:
                        op = op<2?op+1:0;
                        delay = 1;
                        break;
                }
            }
        }
         if(event.type == SDL_KEYUP){
                delay = 1;
                keys[event.key.keysym.sym] = false;
         }

        //If the user has Xed out the window
        if( event.type == SDL_QUIT ){
            //Quit the program
            set_next_state( STATE_EXIT );
        }
    }
}

void Jogo::logica(){
    if(currentLevel->levelFim() == true){
        int newLevel = currentLevel->getNextLevel();
        if(newLevel > 2)
            set_next_state(STATE_ENTRASCORE);
        currentLevel = new Level(newLevel, &personagem);
        personagem.resetaPersonagem();
    }
    if(pausado == false){
        currentLevel->update();
        checkColision();
        personagem.move();
         //The timer's time as a string
        std::stringstream time;
        //Convert the timer's time to a string
        time << "Tempo: " << (myTimer.get_ticks() / 1000.f);
        //Render the time surface
        seconds = TTF_RenderText_Solid( font, time.str().c_str(), textColor );
    }else{
        if(delay == 0){
            if(keys[SDLK_UP])
                op = op>0?op-1:2;
            if(keys[SDLK_DOWN])
                op = op<2?op+1:0;
        }
        delay = delay<5?delay+1:0;
        if(keys[SDLK_RETURN]){
            switch(op){
                case 0:
                    pausado = false;
                    myTimer.unpause();
                    break;
                case 1:
                    break;
                case 2:
                    myTimer.stop();
                    pausado = false;
                    set_next_state(STATE_INICIAL);
                    break;
            }
        }
    }
}

void Jogo::render(){
    if (pausado == false){
        SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );
        apply_surface( 0, 0, background, screen);
        currentLevel->desenha();
        personagem.show();
        apply_surface(  1000, 60, seconds, screen );
    }else{
       SDL_SetAlpha( fundo, SDL_SRCALPHA, alpha );
       apply_surface(0,0,fundo,screen);
       apply_surface( 0, 150, fundopausa, screen );
       apply_surface( 465, setaPos[op], setapausa, screen);
   }
}

