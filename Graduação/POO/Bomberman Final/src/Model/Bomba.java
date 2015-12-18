/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Controller.Fase;
import Library.Consts;
import Library.Posicao;
import Model.Elemento;
import java.awt.Graphics2D;
import java.io.IOException;
import java.io.Serializable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JPanel;

/**
 *
 * @author Owner
 */
public class Bomba extends Elemento implements Serializable{
    
    private long iTimeExplode;
    private long iTimePassed;
    private int iRange;
    private boolean bAutoExplode;
    private boolean bSliding;
    private Consts.DIRECTION dDirection;
    private boolean explodiu;
    
    public Bomba(String imagem, Posicao posicao, int timeexplode, int range, boolean autoexplode) throws IOException{
        super(imagem, posicao);
        this.iTimeExplode = timeexplode;
        this.iRange = range;
        this.bAutoExplode = autoexplode;
        this.iTimePassed = System.currentTimeMillis();
    }

    public void Contagem(long delta){
        if(bAutoExplode){
            if((iTimeExplode * 1000) < delta - iTimePassed)
                Explode();
        }
    }
    
    public void Explode(){
        explodiu = true;
    }
    
    public boolean getExplodiu(){
        return explodiu;
    }
    
    public int getRange(){
        return this.iRange;
    }
    
    public Posicao getPosicao(){
        return this.pPosicao;
    }
    
    public void Kick(Consts.DIRECTION direction){
        this.dDirection = direction;
        this.bSliding = true;
    }
    
    public void Move(Consts.DIRECTION direction){
        switch(direction){
            case UP:
                this.pPosicao.setLinha(this.pPosicao.getLinha()-1);
                break;
            case DOWN:
                this.pPosicao.setLinha(this.pPosicao.getLinha()-1);
                break;
            case LEFT:
                this.pPosicao.setColuna(this.pPosicao.getColuna()-1);
                break;
            case RIGHT:
                this.pPosicao.setColuna(this.pPosicao.getColuna()+1);
                break;
        }
    }
}
