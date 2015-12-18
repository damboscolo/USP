#ifndef HEADERS_H_INCLUDED
#define HEADERS_H_INCLUDED
#include "SDL/SDL.h"
#include "SDL/SDL_image.h"
#include "SDL/SDL_ttf.h"
#include <string>
#include <math.h>
#include <stdio.h>
#include <iostream>
#include <sstream>
#include <dos.h>
using namespace std;

//Screen attributes
const int SCREEN_WIDTH = 1280;
const int SCREEN_HEIGHT = 720;
const int SCREEN_BPP = 32;

//The frame rate
const int FRAMES_PER_SECOND = 20;

//The attributes of the square
const int PERSON_WIDTH = 80;
const int PERSON_HEIGHT = 80;

//Constantes de Direçao e Orientaçao para o Personagem
enum Directions{ LEFT, RIGHT, UP, DOWN, UP_LEFT, UP_RIGHT };
enum GameStates{ STATE_NULL, STATE_INICIAL, STATE_JOGO, STATE_CREDITOS, STATE_SCORE, STATE_HIGHSCORE, STATE_EXIT, STATE_ENTRASCORE};
enum Positions{ BACK, MIDDLE, FRONT };
enum Sides{ SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM };
enum Leveis{ INTRO, LEVEL1 };

//The surfaces
SDL_Surface *tiles[30];
SDL_Surface *screen = NULL;
SDL_Surface *personagemS = NULL;
SDL_Surface *background = NULL;
SDL_Surface *message = NULL;

FILE *score;
int pontuacao;

TTF_Font *font = NULL;
TTF_Font *font2 = NULL;
SDL_Color textColor = { 255, 255, 255 };
SDL_Color blackText = { 0, 0, 0 };
SDL_Color orangeText = { 255, 153, 0 };
SDL_Color blueText = { 44, 74, 95 };

//The event structure
SDL_Event event;

// Inicia a camera
SDL_Rect camera = { 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT };

//Variaveis para guardar o estado
int stateID = STATE_NULL;
int nextState = STATE_NULL;

int tileMax = 30;

// Array de teclas pressionadas, para pressionar multiplas teclas
bool keys[256];

class GameState{
    public:
    bool ok;
    virtual void events() = 0;
    virtual void logica() = 0;
    virtual void render() = 0;
    virtual ~GameState(){};
};

GameState *currentState = NULL;

//State status manager
void set_next_state( int newState );

//State changer
void change_state();


#endif // HEADERS_H_INCLUDED
