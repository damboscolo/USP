/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Library.Consts;
import static Library.Consts.KEYS.KDOWN;
import static Library.Consts.KEYS.KENTER;
import static Library.Consts.KEYS.KUP;
import Library.SpriteLoader;
import Model.Jogo;
import Model.Sprite;
import java.awt.Graphics2D;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Owner
 */
public class Fim extends Tela {
    
    private Sprite fundo, botaoSair, botaoReiniciar, seta, venceu, perdeu;
    private int setaY;
    
    public Fim(Jogo jogo, Graphics2D g) throws IOException{
        super(jogo, g);
        this.setaY = 310;
        fundo = SpriteLoader.get().getSprite("fimFundo.png");
        venceu = SpriteLoader.get().getSprite("fimVenceu.png");
        perdeu = SpriteLoader.get().getSprite("fimPerdeu.png");
        botaoReiniciar = SpriteLoader.get().getSprite("botaoReiniciar.png");
        botaoSair = SpriteLoader.get().getSprite("botaoSair.png");
        seta = SpriteLoader.get().getSprite("seta.png");
    }

    @Override
    public void logic() {
        
    }

    @Override
    public void update() {
        fundo.draw(g, 0, 0);
        if(jogo.getGanhou())
            venceu.draw(g, 200, 300);
        else
            perdeu.draw(g, 200, 300);
        //botaoReiniciar.draw(g, 350, 300);
        //botaoSair.draw(g, 350, 350);
        //seta.draw(g, 320, setaY);
    }

    @Override
    public void keyeventhandle(Consts.KEYS key) {
        switch(key){  
            case KUP:
            case KDOWN:
                setaY = 310;
                break;
            case KENTER:
                if(setaY == 310)
                    System.exit(0);
                break;
        }
    }
    
}
