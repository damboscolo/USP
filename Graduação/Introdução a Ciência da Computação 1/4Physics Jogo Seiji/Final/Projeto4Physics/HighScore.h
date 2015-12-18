class HighScore : public GameState{
    private:
    SDL_Surface *seta;
    SDL_Surface *voltar;
    SDL_Surface *highscore;
    SDL_Surface *scoreBoard;

    FILE *scoreFile;

    char *nomes[20];
    SDL_Surface *nomesS[20];
    SDL_Surface *pontosS[20];
    char tmpNome[200];
    int pontuacoes[20];

    public:
    HighScore();
    ~HighScore();

    //Main loop functions
    void events();
    void logica();
    void render();

};

HighScore::HighScore(){

    seta = load_image("imagens/seta.png");
    voltar = load_image("imagens/voltar.png");
    highscore = load_image("imagens/highscore.png");
    scoreBoard = load_image("imagens/scoreBoard.png");

    scoreFile = fopen("arquivos/score.txt", "r");

    char nome[50];
    if(scoreFile != NULL){
        char c;
        int j, tam, i = 0;
        while(fscanf(scoreFile, "%s : %d\n", nome, &pontuacoes[i]) != EOF){
            tam = strlen(nome) + 1;
            nomes[i] = (char*) malloc(tam * sizeof(char));
            strcpy(nomes[i], nome);
            i++;
        }
    }

}

HighScore::~HighScore(){
    SDL_FreeSurface(seta);
    SDL_FreeSurface(voltar);
    SDL_FreeSurface(highscore);
    SDL_FreeSurface(scoreBoard);
    fclose(scoreFile);
}


void HighScore::events(){
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

void HighScore::logica(){
    if(keys[SDLK_RETURN]){
        nextState = STATE_INICIAL;
    }

}

void HighScore::render(){
    //Fill the screen white
    SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0xFF, 0xFF, 0xFF ) );

    apply_surface( 400, 30, highscore, screen);
    apply_surface( 80, 200, scoreBoard, screen);
    apply_surface( SCREEN_WIDTH - 250, SCREEN_HEIGHT - 70, seta, screen);
    apply_surface( SCREEN_WIDTH - 180, SCREEN_HEIGHT - 70, voltar, screen);

    char pontuacaoEscreve[20][12];

    for(int i = 0; i < 20; i++){
        itoa(pontuacoes[i], pontuacaoEscreve[i], 10);
        //Render the time surface
        nomesS[i] = TTF_RenderText_Solid( font, nomes[i], blueText );
        pontosS[i] = TTF_RenderText_Solid( font, pontuacaoEscreve[i], orangeText );
        apply_surface( 150 + ((i/10) * 590), 210 + 40 * i - (i/10 * 400), nomesS[i], screen);
        apply_surface( 520 + ((i/10) * 590), 210 + 40 * i - (i/10 * 400), pontosS[i], screen);

    }

}
