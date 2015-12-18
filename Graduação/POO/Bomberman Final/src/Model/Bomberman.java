/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Controller.Fase;
import Library.Consts;
import Library.Posicao;
import java.awt.Graphics2D;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import javax.swing.JPanel;

/**
 *
 * @author Owner
 */
public class Bomberman extends Elemento implements Serializable {
    
    private Bomba bTempBomba;
    private Jogo jogo;
    private Fase fase;
    private int bombas = 1;
    private int vidas;
    
    public Bomberman(String imagem, Posicao posicao, Jogo jogo, int vidasIniciais){
        super(imagem, posicao);
        this.jogo = jogo;
        this.fase = (Fase) jogo.getTela();
        this.vidas = vidasIniciais;
    }
    
    public void Move(Consts.DIRECTION dir){
        if(VerificaAndar(dir)){
            switch(dir){
                case UP:
                    pPosicao.setLinha(pPosicao.getLinha()-1);
                    break;
                case DOWN:
                    pPosicao.setLinha(pPosicao.getLinha()+1);
                    break;
                case RIGHT:
                    pPosicao.setColuna(pPosicao.getColuna()+1);
                    break;
                case LEFT:
                    pPosicao.setColuna(pPosicao.getColuna()-1);
                    break;
            }
        }
    }
    
    public boolean VerificaAndar(Consts.DIRECTION pos){
        int i = this.pPosicao.getLinha();
        int j = this.pPosicao.getColuna();
        int k;
        boolean colisao = false;
        Fase tempFase = (Fase) jogo.getTela();
        ArrayList<Bloco> blocos = tempFase.getBlocos();
        ArrayList<Bomba> bombas = tempFase.getBombas();
        switch(pos){
            case UP:
                i--;
                break;
            case DOWN:
                i++;
                break;
            case LEFT:
                j--;
                break;
            case RIGHT:
                j++;
                break;
        }
        for(k = 0; k < blocos.size(); k++){
            if(blocos.get(k).getPosicao().igual(new Posicao(i,j)))
                colisao = true;            
        }
        for(k = 0; k < bombas.size(); k++){
            if(bombas.get(k).getPosicao().igual(new Posicao(i,j)))
                colisao = true;     
        }
        return !colisao;
    }
    
    public Posicao getPosicao(){
        return this.pPosicao;
    }
    
    public void Morre(){
        this.vidas--;
        this.SetPosicao(1,1);
    }
    
    public int getVidas(){
        return this.vidas;
    }
    
    public void setVidas(int vidas){
        this.vidas = vidas;
    }
}
