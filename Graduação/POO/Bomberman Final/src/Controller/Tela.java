/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Library.Consts;
import Library.SpriteLoader;
import Model.Jogo;
import java.awt.Graphics2D;

/**
 *
 * @author Owner
 */
public abstract class Tela {
    
    protected Graphics2D g;
    protected Jogo jogo;
    protected long lastTime, delta;
    
    public Tela(Jogo jogo, Graphics2D gr){
        this.jogo = jogo;
        this.g = gr;
        this.lastTime = 0;
        this.delta = 0;
    }
    
    public abstract void logic();
    public abstract void update();
    public abstract void keyeventhandle(Consts.KEYS key);
    
}
