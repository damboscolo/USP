/*
* Classe do Personagem
*   Atributos:
*       - int dir = Direçao que o personagem esta virado
*       - int ori = Orientaçao do personagem para quando a gravidade mudar ele ficar de cabeça para baixo
*       - int frame = qual frame da animaçao do personagem está no momento
*       - int frameChange = verifica se já pode mudar o frames
*       - int nFrames = quantas vezes deve-se adicionar o frame para ele poder mudar. Controle de velocidade da animacao.
*       - int maxVel = Velocidade maxima atingivel
*       - float acel = coeficiente de aumento de velocidade
*       - float atrito = coeficiente de parada, 0 < atrito < 1 , multiplica-se com a velocidade para diminui-la
*       - bool andando = verifica se o personagem esta andando
*       - bool pulando = verifica se o personagem esta no meio de um pulo
*       - bool subindo = verifica se o personagem esta subindo no pulo
*       - bool caind = verifica se o personagem pode se movimentar no ar
*       - bool colide = vetor das direcoes em que o personagem esta colidindo com alguma coisa
*/
class Personagem{
    private:
    //The collision box of the square
    SDL_Rect box;
    SDL_Rect collision_box;
    SDL_Rect sprite[24][6];

    //The velocity of the square
    int dir, ori, frame, frameChange, nFrames, blockDir;
    //Mapeia os movimentos do personagem no sprite
    int spriteMapping[4][2][3];
    float maxVel, xVel, yVel, acel, atrito;
    bool andando, pulando, subindo, caindo, colide[4];

    public:
    //Initializes the variables
    Personagem();

    //Takes key presses and adjusts the square's velocity
    void handle_input();

    //Moves the square
    void move();

    //Shows the square on the screen
    void show();

    // Movimenta o personagem em relaçao a sua orientacao
    void movimentos();

    void setColide(int c){
        if(c >= 0 && c < 4)
            colide[c] = true;
    }

    void resetColide(){
        for(int i = 0; i < 4; i++){
            colide[i] = false;
        }
    }

    int getVelocityX(){
        return xVel;
    }

    int getVelocityY(){
        return yVel;
    }

    int getOri(){
        return ori;
    }

    int getAcel(){
        return acel;
    }

    void setOri(int orientacao){
        ori = orientacao;
    }

    void update_collision_box();

    void resetaPosicao(){
        box.x = 70;
        box.y = 600;
    }

    void resetaPersonagem(){
        ori = DOWN;
        dir = RIGHT;
        xVel = 0;
        yVel = 0;
        resetaPosicao();
    }

    SDL_Rect getDimensions();
};

Personagem::Personagem(){
    //Initialize the offsets
    resetaPosicao();

    //Set the square's dimensions
    box.w = PERSON_WIDTH;
    box.h = PERSON_HEIGHT;

    //Initialize the velocity
    xVel = 0.0f;
    yVel = 0.0f;

    dir = RIGHT; // Começa virado para direita
    ori = DOWN; //Começa com a gravidade para baixo
    maxVel = 13.0f; //Coloca uma velocidade maxima
    acel = 2.0f; // Acelera de 1 em 1 até chegar na maxVel
    atrito = 0.7f; // Tira 20% da velocidade cada vez que o personagem nao estiver se movimentando

    frame = 0; // Começa com o a animaçao do personagem no frame 0
    frameChange = 0; // Verifica se já pode mudar o frame da animaçao
    nFrames = 2;

    andando = false;
    pulando = false;
    subindo = false;
    caindo = false;
    colide[LEFT] = false;
    colide[RIGHT] = false;
    colide[UP] = false;
    colide[DOWN] = false;

    update_collision_box();

    spriteMapping = { { { 21, 5, 13 }, { 20, 4, 12 } },
                      { { 23, 7, 15 }, { 22, 6, 14 } },
                      { { 19, 3, 11 }, { 18, 2, 10 } },
                      { { 17, 1, 9  }, { 16, 0, 8  } } };

    for(int i = 0; i < 24; i++){
        for(int j = 0; j < 6; j++){
            sprite[i][j].x = 80 * j;
            sprite[i][j].y = 80 * i;
            sprite[i][j].w = 80;
            sprite[i][j].h = 80;
        }
    }
}


void Personagem::handle_input(){

    int key = event.key.keysym.sym;

    //Verifica se uma tecla foi apertada e modifica o estado dela para true no vetor global de teclas
   if(event.type == SDL_KEYDOWN){
        keys[key] = true;

        //Verifica se a tecla da esquerda foi apertada remove a da direita e vice-versa. Melhora a movimentacao
        if(key == SDLK_LEFT)
            keys[SDLK_RIGHT] = false;
        if(key == SDLK_RIGHT)
            keys[SDLK_LEFT] = false;
        if(key == SDLK_r)
            resetaPersonagem();

    // Verifica se uma tecla foi desapertada e modifica o estado dela para false no vetor global de teclas
   }else if(event.type == SDL_KEYUP){
        keys[key] = false;

        // Se parou de aperta para esquerda ou direita para de andar
        if(key == SDLK_LEFT || key == SDLK_RIGHT){
            andando = false;
            //Se nao estive pulando volta para o primeiro frame parado
            if(pulando == false)
                frame = 0;
        }
    }
}

void Personagem::move(){

    bool tiraPulo = false; // Verifica se o estado de pulo deve ser removido, usado mais abaixo
    update_collision_box();

    // Muda a direção no ar ou andando
    if(keys[SDLK_LEFT] || keys[SDLK_RIGHT]){
        dir = keys[SDLK_LEFT]?LEFT:RIGHT;
        if(pulando == false)
            andando = true;
    }

    // Faz pular e se estiver no meio do ar faz cair
    if(pulando == false){
        if(keys[SDLK_UP] || !colide[ori]){
            dir == LEFT?UP_LEFT:UP_RIGHT;
            pulando = true;
            if(keys[SDLK_UP])
                subindo = true;
            andando = false;
            frame = 0;
        }
    }

    movimentos();

    //Aplicando a gravidade
    if(!colide[ori]){
        //Verifica de as velocidades nao ultrapassam o maximo *2, pois mesmo com gravidade corpos tem velocidade maxima
        switch(ori){
            case DOWN: yVel += acel * 2; yVel = yVel > maxVel?maxVel*2:yVel; break;
            case UP : yVel -= acel * 2; yVel = yVel < -maxVel?-maxVel*2:yVel; break;
            case LEFT: xVel -= acel * 2; xVel = xVel < -maxVel?-maxVel*2:xVel; break;
            case RIGHT: xVel += acel * 2; xVel = xVel > maxVel?maxVel*2:xVel; break;
        }
    }

    // Verifica se o personagem colidiu e volta o espaço que ele andou e cancela sua velocidade para ele nao atravessar personagens
    if(colide[LEFT] && xVel < 0){
        box.x -= xVel-(acel*2);
        xVel = 0;
    }
    if(colide[RIGHT] && xVel > 0){
        box.x -= xVel+(acel*2);
        xVel = 0;
    }
    if(colide[UP] && yVel < 0){
        box.y -= yVel+(acel*2);
        yVel = 0;
    }
    if(colide[DOWN] && yVel > 0){
        box.y -= yVel-(acel*2);
        yVel = 0;
    }

    // Verifica se colidiu em algo que nao seja o chao e faz cair
    for(int i = 0; i < 4; i++){
        if(colide[i] == true && i != ori)
            caindo = true;
    }

    //Move o personagem em si
    box.x += xVel;
    box.y += yVel;

    // Depois de pular volta para animação normal se ele tocar no chão relativo a orientação
    if(colide[ori]){
        switch(ori){
            case LEFT:
                tiraPulo = xVel <= 0?true:false;
                break;
            case RIGHT:
                tiraPulo = xVel >= 0?true:false;
                break;
            case UP:
                tiraPulo = yVel <= 0?true:false;
                break;
            case DOWN:
                tiraPulo = yVel >= 0?true:false;
                break;
        }
        if(!subindo && pulando && tiraPulo){
            pulando = false;
            caindo = false;
        }
    }

    // Se o personagem passar da tela volta pro começo da fase
    if(box.x + PERSON_WIDTH - camera.x > SCREEN_WIDTH || box.x < 0 || box.y < 0 || box.y - camera.y > SCREEN_HEIGHT)
        resetaPosicao();

}

//Desenha o personagem na tela
void Personagem::show(){
    //Arruma o tempo dos frames para o personagem nao ficar animado muito rapido
    frameChange = frameChange<(pulando==true?nFrames*2:nFrames)?frameChange+1:0;
    if(frameChange != 0 && frameChange % (pulando==true?nFrames*2:nFrames) == 0)
        frame = frame<5?frame+1:0;

    // Calcula qual sprite deve ser usado de acordo com a orientação da tela e a direção que o personagem esta virado, e também se ele esta parado, andando ou pulando
    int dir_map = dir == LEFT || dir == UP_LEFT?0:1;
    int state_map = andando == true?1:pulando==true?2:0;
    int dir_ori = spriteMapping[ori][dir_map][state_map];

    apply_surface( box.x - camera.x, box.y - camera.y, personagemS, screen, &sprite[dir_ori][frame] );

}

/*
*   Moviementos
*   Funcao que calcula para qual direçao o personagem deve se mecher em relaçao a sua orientaçao e direçao
*/
void Personagem::movimentos(){
    if(andando == true){
        if(!colide[dir]){
            //Acelera o personagem para adicionar a velocidade atual
            switch(ori){
                case DOWN:
                    switch(dir){
                        case LEFT: xVel -= acel; break;
                        case RIGHT: xVel += acel; break;
                    }
                    break;
                case UP:
                    switch(dir){
                        case LEFT: xVel += acel; break;
                        case RIGHT: xVel -= acel; break;
                    }
                    break;
                case LEFT:
                    switch(dir){
                        case LEFT: yVel -= acel; break;
                        case RIGHT: yVel += acel; break;
                    }
                    break;
                case RIGHT:
                    switch(dir){
                        case LEFT: yVel += acel; break;
                        case RIGHT: yVel -= acel; break;
                    }
                    break;
            }
        }
        //Verifica de as velocidades nao ultrapassam o maximo
        xVel = xVel > maxVel?maxVel:xVel;
        xVel = xVel < -maxVel?-maxVel:xVel;
        yVel = yVel > maxVel?maxVel:yVel;
        yVel = yVel < -maxVel?-maxVel:yVel;
    }else if(pulando == true && subindo == false && (keys[SDLK_LEFT] || keys[SDLK_RIGHT]) && !colide[dir] && caindo == false){ // Depois de fazer a força pra pular o personagem pode mudar a direcao do pulo no ar
        switch(ori){
            case DOWN:
                switch(dir){
                    case LEFT: xVel -= acel; break;
                    case RIGHT: xVel += acel; break;
                }
                xVel = xVel > maxVel?maxVel:xVel;
                xVel = xVel < -maxVel?-maxVel:xVel;
                break;
            case UP:
                switch(dir){
                    case LEFT: xVel += acel; break;
                    case RIGHT: xVel -= acel; break;
                }
                xVel = xVel > maxVel?maxVel:xVel;
                xVel = xVel < -maxVel?-maxVel:xVel;
                break;
            case LEFT:
                switch(dir){
                    case LEFT: yVel -= acel; break;
                    case RIGHT: yVel += acel; break;
                }
                yVel = yVel > maxVel?maxVel:yVel;
                yVel = yVel < -maxVel?-maxVel:yVel;
                break;
            case RIGHT:
                switch(dir){
                    case LEFT: yVel += acel; break;
                    case RIGHT: yVel -= acel; break;
                }
                yVel = yVel > maxVel?maxVel:yVel;
                yVel = yVel < -maxVel?-maxVel:yVel;
                break;
        }
    }else if(pulando == true && subindo == true){//Faz a força para o pulo de acordo com a orientação da fase
        switch(ori){
            case DOWN:
                yVel -= maxVel * 3;
                break;
            case UP:
                yVel += maxVel * 3;
                break;
            case LEFT:
                xVel += maxVel * 3;
                break;
            case RIGHT:
                xVel -= maxVel * 3;
                break;
        }
        subindo = false;
    }else{
        //Calcula Atrito
        if(pulando == false){
            xVel *= atrito;
            yVel *= atrito;
        }
        //Se a velocidade for proxima a zero, torna-se 0, pois o atrito gera numeros com varias casas decimais proximos a zero e pode demorar a parar por completo
        xVel = xVel < 0.5 && xVel > -0.5?0:xVel;
        yVel = yVel < 0.5 && yVel > -0.5?0:yVel;
    }
}

//Retorna as dimensoes da area de colisao do personagem
SDL_Rect Personagem::getDimensions(){
    return collision_box;
}

//Define a area de colisao do personagem de acordo com a orientação do mapa
void Personagem::update_collision_box(){
    switch(ori){
        case LEFT:
            collision_box.x = box.x;
            collision_box.y = box.y + 15;
            collision_box.w = box.w;
            collision_box.h = box.h - 30;
            break;
        case RIGHT:
            collision_box.x = box.x;
            collision_box.y = box.y + 15;
            collision_box.w = box.w;
            collision_box.h = box.h - 30;
            break;
        case UP:
            collision_box.x = box.x + 15;
            collision_box.y = box.y;
            collision_box.w = box.w - 30;
            collision_box.h = box.h;
            break;
        case DOWN:
            collision_box.x = box.x + 15;
            collision_box.y = box.y;
            collision_box.w = box.w - 30;
            collision_box.h = box.h;
            break;
    }
}
