class EnviaScore : public GameState{
    private:

    SDL_Surface *fundoScore;
    SDL_Surface *titulo;
    SDL_Surface *sair;
    SDL_Surface *text;

    //The storage string
    std::string str;

    public:
    EnviaScore();
    ~EnviaScore();

    //Main loop functions
    void events();
    void logica();
    void render();

    //Handles input
    void handle_input();

    //Shows the message on screen
    void show_centered();

};

EnviaScore::EnviaScore(){
    //titulo = load_image("imagens/tituloScore.png");
    //fundoScore = load_image("imagens/fundo.png");
    score = fopen ( "arquivos/score.txt", "a");

    //Initialize the string
    str = "";

    //Initialize the surface
    text = NULL;

    //Enable Unicode
    SDL_EnableUNICODE( SDL_ENABLE );
}

EnviaScore::~EnviaScore(){
    SDL_FreeSurface(titulo);
    SDL_FreeSurface(fundoScore);

    //Free text surface
    SDL_FreeSurface( text );

    fclose (score);

    //Disable Unicode
    SDL_EnableUNICODE( SDL_DISABLE );

}

void EnviaScore::handle_input()
{
    //If a key was pressed
    if( event.type == SDL_KEYDOWN )
    {
        //Keep a copy of the current version of the string
        std::string temp = str;

        //If the string less than maximum size
        if( str.length() <= 16 )
        {
            //If the key is a space
            if( event.key.keysym.unicode == (Uint16)' ' )
            {
                //Append the character
                str += (char)event.key.keysym.unicode;
            }
            //If the key is a number
            else if( ( event.key.keysym.unicode >= (Uint16)'0' ) && ( event.key.keysym.unicode <= (Uint16)'9' ) )
            {
                //Append the character
                str += (char)event.key.keysym.unicode;
            }
            //If the key is a uppercase letter
            else if( ( event.key.keysym.unicode >= (Uint16)'A' ) && ( event.key.keysym.unicode <= (Uint16)'Z' ) )
            {
                //Append the character
                str += (char)event.key.keysym.unicode;
            }
            //If the key is a lowercase letter
            else if( ( event.key.keysym.unicode >= (Uint16)'a' ) && ( event.key.keysym.unicode <= (Uint16)'z' ) )
            {
                //Append the character
                str += (char)event.key.keysym.unicode;
            }
        }

        //If backspace was pressed and the string isn't blank
        if( ( event.key.keysym.sym == SDLK_BACKSPACE ) && ( str.length() != 0 ) )
        {
            //Remove a character from the end
            str.erase( str.length() - 1 );
        }

        //If the string was changed
        if( str != temp )
        {
            //Free the old surface
            SDL_FreeSurface( text );

            //Render a new text surface
            text = TTF_RenderText_Solid( font, str.c_str(), textColor );
        }
    }


}

void EnviaScore::show_centered()
{
    //If the surface isn't blank
    if( text != NULL )
    {
        //Show the name
        apply_surface( ( SCREEN_WIDTH - text->w ) / 2, ( SCREEN_HEIGHT - text->h ) / 2, text, screen );
    }
}

void EnviaScore::events(){


    //While there's events to handle
    while( SDL_PollEvent( &event ) ){
        //If the user hasn't entered their name yet

            //Set the message
            message = TTF_RenderText_Solid( font, "New High Score! Enter Name:", textColor );
            //Get user input
            handle_input();

            //If the enter key was pressed
            if( ( event.type == SDL_KEYDOWN ) && ( event.key.keysym.sym == SDLK_RETURN ) )
            {
                fprintf(score, "%s : %d\n", str.c_str(),pontuacao);
                fclose(score);
                set_next_state(STATE_INICIAL);
            }



        //If the user has Xed out the window
        if( event.type == SDL_QUIT ){
            //Quit the program
            set_next_state( STATE_EXIT );
        }
    }
}

void EnviaScore::logica(){


}

void EnviaScore::render(){
    //Apply the background
    apply_surface( 0, 0, fundoScore, screen );
    SDL_FillRect( screen, &screen->clip_rect, SDL_MapRGB( screen->format, 0x00, 0x00, 0x00 ) );
    //Show the message
    apply_surface( ( SCREEN_WIDTH - message->w ) / 2, ( ( SCREEN_HEIGHT / 2 ) - message->h ) / 2, message, screen );

    //Show the name on the screen
    show_centered();

}
