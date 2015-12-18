
bool check_collision( SDL_Rect A, SDL_Rect B ){
    //The sides of the rectangles
    int leftA, leftB;
    int rightA, rightB;
    int topA, topB;
    int bottomA, bottomB;

    //Calculate the sides of rect A
    leftA = A.x;
    rightA = A.x + A.w;
    topA = A.y;
    bottomA = A.y + A.h;

    //Calculate the sides of rect B
    leftB = B.x;
    rightB = B.x + B.w;
    topB = B.y;
    bottomB = B.y + B.h;

    //If any of the sides from A are outside of B
    if( bottomA <= topB )
        return false;
    if( topA >= bottomB )
        return false;
    if( rightA <= leftB )
        return false;
    if( leftA >= rightB )
        return false;

    //If none of the sides from A are outside B
    return true;
}

void colisao_personagem_objeto(Personagem *per, SDL_Rect t){

    SDL_Rect p = per->getDimensions();

    //Dois vetores com 4 lados dos dois objetos.
    int sidesA[4] = { p.x, p.x + p.w, p.y, p.y + p.h };
    int sidesB[4] = { t.x, t.x + t.w, t.y, t.y + t.h };

    if(sidesB[SIDE_RIGHT] >= sidesA[SIDE_LEFT] && sidesB[SIDE_LEFT] <= sidesA[SIDE_RIGHT] && sidesB[SIDE_BOTTOM] >= sidesA[SIDE_TOP] && sidesB[SIDE_TOP] <= sidesA[SIDE_BOTTOM]){
        if(sidesB[SIDE_LEFT] < sidesA[SIDE_LEFT] && sidesB[SIDE_RIGHT] > sidesA[SIDE_LEFT] && ((sidesB[SIDE_TOP] < sidesA[SIDE_BOTTOM] && sidesB[SIDE_BOTTOM] > sidesA[SIDE_BOTTOM]) || (sidesB[SIDE_BOTTOM] > sidesA[SIDE_TOP] && sidesB[SIDE_TOP] < sidesA[SIDE_TOP]))){
            per->setColide(LEFT);
        }
        if(sidesB[SIDE_RIGHT] > sidesA[SIDE_RIGHT] && sidesB[SIDE_LEFT] < sidesA[SIDE_RIGHT] && ((sidesB[SIDE_TOP] < sidesA[SIDE_BOTTOM] && sidesB[SIDE_BOTTOM] > sidesA[SIDE_BOTTOM]) || (sidesB[SIDE_BOTTOM] > sidesA[SIDE_TOP] && sidesB[SIDE_TOP] < sidesA[SIDE_TOP]))){
            per->setColide(RIGHT);
        }
        if(sidesB[SIDE_TOP] < sidesA[SIDE_TOP] && sidesB[SIDE_BOTTOM] > sidesA[SIDE_TOP]){
            per->setColide(UP);
        }
        if(sidesB[SIDE_BOTTOM] > sidesA[SIDE_BOTTOM] && sidesB[SIDE_TOP] < sidesA[SIDE_BOTTOM]){
            per->setColide(DOWN);
        }
    }
}
