/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Controller.Fase;
import Library.Consts;
import static Library.Consts.DIRECTION.DOWN;
import static Library.Consts.DIRECTION.LEFT;
import static Library.Consts.DIRECTION.RIGHT;
import static Library.Consts.DIRECTION.UP;
import Library.Posicao;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author Eduardo
 */
public class Inimigo extends Elemento implements Serializable{
    
    private Jogo jogo;
    private Fase fase;
    private boolean anda = false;
    private Consts.DIRECTION direction;
    
    public Inimigo(String imagem, Posicao posicao, Jogo jogo){
        super(imagem, posicao);
        this.jogo = jogo;
        this.fase = (Fase) jogo.getTela();
    }
    
    public void Move(Consts.DIRECTION dir){
        if(anda){
            while(anda){
                if(VerificaAndar(dir)){
                    anda = false;
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
                }else
                    DecideAndar();
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
    
    public void DecideAndar(){
        int action = (int) (Math.random()*5);
        switch(action){
            case 0:
                anda = false;
                break;
            case 1:
                this.direction = UP;
                anda = true;
                break;
            case 2:
                this.direction = DOWN;
                anda = true;
                break;
            case 3:
                this.direction = LEFT;
                anda = true;
                break;
            case 4:
                this.direction = RIGHT;
                anda = true;
                break;
        }
    }
    public boolean getAndar(){
        return this.anda;
    }
    public Consts.DIRECTION getDirection(){
        return this.direction;
    }
}
