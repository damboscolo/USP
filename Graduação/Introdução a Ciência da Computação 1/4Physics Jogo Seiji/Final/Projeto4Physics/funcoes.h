#ifndef FUNCOES_H_INCLUDED
#define FUNCOES_H_INCLUDED

#include "headers.h"

SDL_Surface *load_image( std::string filename ){
    //The image that's loaded
    SDL_Surface* loadedImage = NULL;

    //The optimized surface that will be used
    SDL_Surface* optimizedImage = NULL;

    //Load the image
    loadedImage = IMG_Load( filename.c_str() );

    //If the image loaded
    if( loadedImage != NULL ){
        //Create an optimized surface
        optimizedImage = SDL_DisplayFormat( loadedImage );

        //Free the old surface
        SDL_FreeSurface( loadedImage );

        //If the surface was optimized
        if(optimizedImage != NULL){
            //Color key surface
            SDL_SetColorKey( optimizedImage, SDL_SRCCOLORKEY, SDL_MapRGB( optimizedImage->format, 255,255, 255 ) );
        }
    }

    //Return the optimized surface
    return optimizedImage;
}

void apply_surface( int x, int y, SDL_Surface* source, SDL_Surface* destination, SDL_Rect* clip ){
    //Holds offsets
    SDL_Rect offset;

    //Get offsets
    offset.x = x;
    offset.y = y;

    //Blit
    SDL_BlitSurface( source, clip, destination, &offset );
}

bool init(){
    //Initialize all SDL subsystems
    if( SDL_Init( SDL_INIT_EVERYTHING ) == -1 )
    {
        return false;
    }

    if( TTF_Init() == -1 ) {
        return false;
    }

    //Set up the screen
    screen = SDL_SetVideoMode( SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, SDL_SWSURFACE );

    //If there was an error in setting up the screen
    if( screen == NULL )
    {
        return false;
    }

    //Set the window caption
    SDL_WM_SetCaption( "4Physics", NULL );

    //If everything initialized fine
    return true;
}

bool load_files(){

    font = TTF_OpenFont( "VeraMoBI.ttf", 28 );
    font2 = TTF_OpenFont( "VeraMoBI.ttf", 22 );

    if(font == NULL){
        return false;
    }

    //If everything loaded fine
    return true;
}

void clean_up(){

    if(tiles != NULL){
        for(int i = 0; i < tileMax; i++){
            SDL_FreeSurface(tiles[i]);
        }
    }

    //Quit SDL
    SDL_Quit();
}

/*
*   Funçao para cadastrar e carregar os tiles de um arquivo
*   Saida: Grava no vetor tiles a SDL_Surface do tile
*/
void criaTiles(){
    tiles[1] = load_image("imagens/bloco.png");
    tiles[2] = load_image("imagens/blocoGravidade.png");
    tiles[3] = load_image("imagens/blocoGravidade.png");
    tiles[4] = load_image("imagens/blocoGravidade.png");
    tiles[5] = load_image("imagens/blocoGravidade.png");
    tiles[6] = load_image("imagens/portal.png");
}


void set_next_state( int newState ){
    //If the user doesn't want to exit
    if( nextState != STATE_EXIT )
        nextState = newState;
}

void change_state(){
    //If the state needs to be changed
    if( nextState != STATE_NULL ){
        //Delete the current state
        if( nextState != STATE_EXIT )
            delete currentState;

        //Change the state
        switch( nextState ){
            case STATE_INICIAL:
                currentState = new TelaInicial();
                break;
            case STATE_JOGO:
                currentState = new Jogo();
                break;
            case STATE_CREDITOS:
                currentState = new Creditos();
                break;
            case STATE_HIGHSCORE:
                currentState = new HighScore();
                break;
            case STATE_ENTRASCORE:
                currentState = new EnviaScore();
                break;
        }

        //Change the current state ID
        stateID = nextState;
        resetaKeys();

        //NULL the next state ID
        nextState = STATE_NULL;
    }
}

bool colisao_personagem_objeto(Personagem *per, SDL_Rect t, bool colidira){

    SDL_Rect p = per->getDimensions();
    int xVel = per->getVelocityX();
    int yVel = per->getVelocityY();
    int ori = per->getOri();
    int acel = per->getAcel();

    switch(ori){
        case DOWN: yVel += acel * 2; break;
        case UP : yVel -= acel * 2; break;
        case LEFT: xVel -= acel * 2; break;
        case RIGHT: xVel += acel * 2; break;
    }

    //Dois vetores com 4 lados dos dois objetos.
    int sidesA[4] = { p.x + xVel, p.x + p.w + xVel, p.y + yVel, p.y + p.h + yVel };
    int sidesB[4] = { t.x, t.x + t.w, t.y, t.y + t.h };
    int centerAx = p.x + xVel + p.w/2;
    int centerBx = t.x + t.w/2;
    int centerAy = p.y + yVel + p.h/2;
    int centerBy = t.y + t.h/2;
    int distanciaX = centerAx > centerBx?centerAx-centerBx:centerBx-centerAx;
    int distanciaY = centerAy > centerBy?centerAy-centerBy:centerBy-centerAy;
    bool colide[4], colidiu = false;
    colide[LEFT] = false;
    colide[RIGHT] = false;
    colide[UP] = false;
    colide[DOWN] = false;


    if(distanciaX <= p.w/2 + t.w/2 && distanciaY <= (p.h/2) + (t.h/2)){
        if(sidesB[SIDE_BOTTOM] >= sidesA[SIDE_BOTTOM] && sidesB[SIDE_TOP] <= sidesA[SIDE_BOTTOM]){
            colide[DOWN] = true;
            colidiu = true;
        }
        if(sidesB[SIDE_TOP] <= sidesA[SIDE_TOP] && sidesB[SIDE_BOTTOM] >= sidesA[SIDE_TOP]){
            colide[UP] = true;
            colidiu = true;
        }
        if(sidesB[SIDE_LEFT] <= sidesA[SIDE_LEFT] && sidesB[SIDE_RIGHT] >= sidesA[SIDE_LEFT]){
            colide[LEFT] = true;
            colidiu = true;
        }
        if(sidesB[SIDE_RIGHT] >= sidesA[SIDE_RIGHT] && sidesB[SIDE_LEFT] <= sidesA[SIDE_RIGHT]){
            colide[RIGHT] = true;
            colidiu = true;
        }
    }

    if(colide[DOWN]){
        if(colide[LEFT] && distanciaX > distanciaY){
            colide[DOWN] = false;
        }else{
            colide[LEFT] = false;
        }
        if(colide[RIGHT] && distanciaX > distanciaY){
            colide[DOWN] = false;
        }else{
            colide[RIGHT] = false;
        }
    }

    if(colide[UP]){
        if(colide[LEFT] && distanciaX > distanciaY){
            colide[UP] = false;
        }else{
            colide[LEFT] = false;
        }
        if(colide[RIGHT] && distanciaX > distanciaY){
            colide[UP] = false;
        }else{
            colide[RIGHT] = false;
        }
    }

    if(colidira == true){
        for(int i = 0; i < 4; i++){
            if(colide[i])
                per->setColide(i);
        }
    }

    return colidiu;

}

void resetaKeys(){
    for(int i = 0; i < 256; i++)
        keys[i] = false;
}

#endif // FUNCOES_H_INCLUDED
