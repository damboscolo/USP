class GameState{
    public:
    bool ok;
    virtual void events() = 0;
    virtual void logica() = 0;
    virtual void render() = 0;
    virtual ~GameState(){};
};
