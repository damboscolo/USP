//The headers
#include "headers.h"
#include "funcoes_prototipos.h"
#include "personagem.h"
#include "Timer.h"
#include "Tile.h"
#include "BlocoBasico.h"
#include "BlocoGravidade.h"
#include "Portal.h"
#include "Level.h"
#include "Jogo.h"
#include "TelaInicial.h"
#include "Creditos.h"
#include "HighScore.h"
#include "EnviaScore.h"
#include "funcoes.h"

int main( int argc, char* args[] ){

    //The frame rate regulator
    Timer fps;

    //Initialize
    if( init() == false )
        return 1;

    //Load the files
    if( load_files() == false )
        return 1;

    stateID = STATE_INICIAL;

    currentState = new TelaInicial();

    //While the user hasn't quit
    while( stateID != STATE_EXIT ){
        //Start the frame timer
        fps.start();

        //if(!currentState->ok)
          //  system("pause");

        //Do state event handling
        currentState->events();

        //Do state logic
        currentState->logica();

        //Change state if needed
        change_state();

        //Do state rendering
        currentState->render();

        //Update the screen
        if( SDL_Flip( screen ) == -1 )
        {
            return 1;
        }

        //Cap the frame rate
        if( fps.get_ticks() < 1000 / FRAMES_PER_SECOND )
            SDL_Delay( ( 1000 / FRAMES_PER_SECOND ) - fps.get_ticks() );
    }

    //Clean up
    clean_up();

    return 0;
}
