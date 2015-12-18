/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Library.Consts;
import Library.SpriteLoader;
import Model.Jogo;
import Model.Sprite;
import java.awt.Graphics2D;
import java.io.IOException;

/**
 *
 * @author Owner
 */
public class Inicio extends Tela{
    
    private Sprite fundo, botaoInicio, botaoSair, botaoContinuar, botaoConfiguracoes, seta;
    private int setaY, sairY, configY;
    
    public Inicio(Jogo jogo, Graphics2D g) throws IOException{
        super(jogo, g);
        this.setaY = 310;
        fundo = SpriteLoader.get().getSprite("inicioFundo.png");
        botaoInicio = SpriteLoader.get().getSprite("botaoInicio.png");
        botaoContinuar = SpriteLoader.get().getSprite("botaoContinuar.png");
        botaoConfiguracoes = SpriteLoader.get().getSprite("botaoConfiguracoes.png");
        botaoSair = SpriteLoader.get().getSprite("botaoSair.png");
        seta = SpriteLoader.get().getSprite("seta.png");
        this.sairY = jogo.hasSave?400:450;
        this.configY = jogo.hasSave?350:400;
    }

    @Override
    public void logic() {
        
    }

    @Override
    public void update() {
        fundo.draw(g, 0, 0);
        botaoInicio.draw(g, 325, 300);
        if(jogo.hasSave)
            botaoContinuar.draw(g, 325, 350);
        botaoConfiguracoes.draw(g, 325, configY);
        botaoSair.draw(g, 325, sairY);
        seta.draw(g, 295, setaY);
    }

    @Override
    public void keyeventhandle(Consts.KEYS key) {
        switch(key){
            case KUP:
                if(jogo.hasSave)
                    setaY = setaY > 310?setaY-50:460;
                else
                    setaY = setaY > 310?setaY-50:410;
                break;
            case KDOWN:
                if(jogo.hasSave)
                    setaY = setaY < 460?setaY+50:310;
                else
                    setaY = setaY < 410?setaY+50:310;
                break;
            case KENTER:
                if(setaY == 310)
                    jogo.ComecarJogo();
                if(setaY == 360){
                    if(jogo.hasSave)
                        jogo.CarregaJogo();
                    else
                        jogo.Configuracoes();
                }
                if(setaY == 410){
                    if(jogo.hasSave)
                        jogo.Configuracoes();
                    else
                        System.exit(0);
                }
                    
                if(setaY == 460)
                    System.exit(0);
                break;
        }
    }
    
}
