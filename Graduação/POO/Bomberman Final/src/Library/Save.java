/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import View.Mapas;
import java.io.IOException;
import java.io.Serializable;

/**
 *
 * @author Owner
 */
public class Save implements Serializable{
    
    private int fase, vidas, bombas;
    private Posicao pos;
    private Mapa mapa;
    private static final long serialVersionUID = 1L;
    
    public Save(int fase, int vidas, int bombas) throws IOException{
        this.fase = fase;
        this.vidas = vidas;
        this.bombas = bombas;
        this.pos = new Posicao(0,0);
        this.mapa = new Mapa(Mapas.MAPAS[fase]);
    }
    
    public void setFase(int fase){
        this.fase = fase;
    }
    
    public void setVidas(int vidas){
        this.vidas = vidas;
    }
    
    public void setBombas(int bombas){
        this.bombas = bombas;
    }
    
    public void setPosicao(Posicao pos){
        this.pos.SetPosicao(pos.getLinha(), pos.getColuna());
    }
    
    public void setMapa(Mapa mapa){
        this.mapa = mapa;
    }
    
    public int getFase(){
        return this.fase;
    }
    
    public int getVidas(){
        return this.vidas;
    }
    
    public int getBombas(){
        return this.bombas;
    }
    
    public Posicao getPosicao(){
        return this.pos;
    }
    
    public Mapa getMapa(){
        return this.mapa;
    }
    
    public String toString(){
        StringBuilder str = new StringBuilder();
        str.append("Fase = "+this.fase+"\n");
        str.append("Vidas = "+this.vidas+"\n");
        str.append("Bombas = "+this.bombas+"\n");
        str.append("Posicao = "+this.pos.toString()+"\n");
        return str.toString();
    }
}
