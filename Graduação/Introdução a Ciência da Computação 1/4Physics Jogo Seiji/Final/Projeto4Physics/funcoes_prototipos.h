SDL_Surface *load_image( std::string filename );

void apply_surface( int x, int y, SDL_Surface* source, SDL_Surface* destination, SDL_Rect* clip = NULL );

bool init();

bool load_files();

void clean_up();

void criaTiles();

void set_next_state( int newState );

void change_state();

void resetaKeys();
