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
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.io.IOException;

/**
 *
 * @author Owner
 */
public class Configuracoes extends Tela{
    
    
    private Sprite botaoSalvar, botaoVoltar, seta, seta2, setaInvertida;
    private int setaY;
    private boolean editandoAutoSave = false;
    private boolean editandoVidas = false;
    
    public Configuracoes(Jogo jogo, Graphics2D g) throws IOException{
        super(jogo, g);
        this.setaY = 190;
        botaoSalvar = SpriteLoader.get().getSprite("botaoSalvar.png");
        botaoVoltar = SpriteLoader.get().getSprite("botaoVoltar.png");
        seta = SpriteLoader.get().getSprite("seta.png");
        seta2 = SpriteLoader.get().getSprite("seta.png");
        setaInvertida = SpriteLoader.get().getSprite("setaInvertida.png");
    }


    @Override
    public void logic() {
    }

    @Override
    public void update() {
        Font fonteTitulo = new Font("Verdana", Font.BOLD, 36);
        Font fonteMenuItens = new Font("Verdana", Font.BOLD, 16);
        g.setColor(Color.BLACK);
        g.setFont(fonteTitulo);
        g.drawString("Configurações", 300, 75);
        g.setFont(fonteMenuItens);
        if(editandoAutoSave){
            g.setColor(Color.RED.darker());
            setaInvertida.draw(g, 500, 190);
            seta2.draw(g, 600, 190);
        }
        g.drawString("Intervalo AutoSave", 300, 210);
        g.drawString(""+(jogo.autoSaveDelay/1000), 550, 210);
        g.setColor(Color.BLACK);
        if(editandoVidas){
            g.setColor(Color.RED.darker());
            seta2.draw(g, 600, 290);
            setaInvertida.draw(g, 500, 290);
        }
        g.drawString("Vidas Iniciais", 320, 310);
        g.drawString(""+jogo.vidasIniciais, 550, 310);
        
        botaoSalvar.draw(g, 370, 380);
        botaoVoltar.draw(g, 370, 480);
        seta.draw(g, 250, setaY);
    }

    @Override
    public void keyeventhandle(Consts.KEYS key) {
        switch(key){
            case KUP:
                setaY = setaY > 190 ? setaY - 100 : 490;
                break;
            case KDOWN:
                setaY = setaY < 490 ? setaY + 100 : 190;
                break;
            case KENTER:
                switch(setaY){
                    case 190:
                        editandoAutoSave = editandoAutoSave?false:true;
                        editandoVidas = false;
                        break;
                    case 290:
                        editandoVidas = editandoVidas?false:true;
                        editandoAutoSave = false;
                        break;
                    case 390:
                        jogo.SalvaConfiguracao();
                    case 490:
                        jogo.voltarInicio();                        
                        break;
                }
                break;
            case KLEFT:
                if(editandoAutoSave){
                    if(jogo.autoSaveDelay > 10000)
                        jogo.autoSaveDelay -= 1000;
                }
                if(editandoVidas){
                    if(jogo.vidasIniciais > 1)
                        jogo.vidasIniciais -= 1;
                }
                break;
            case KRIGHT:
                if(editandoAutoSave){
                    if(jogo.autoSaveDelay < 120000)
                        jogo.autoSaveDelay += 1000;
                }
                if(editandoVidas){
                    if(jogo.vidasIniciais < 5)
                        jogo.vidasIniciais += 1;
                }
                break;
        }
    }
    
}
