/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Library.Posicao;
import java.io.IOException;
import java.io.Serializable;

/**
 *
 * @author Eduardo
 */
public class Fogo extends Elemento implements Serializable{
    
    private long iTimeApaga;
    private long iTimePassed;
    private boolean bApaga = false;
 
    public Fogo(String imagem, Posicao posicao, long timeapaga) throws IOException{
        super(imagem, posicao);
        this.iTimeApaga = timeapaga;
        this.iTimePassed = System.currentTimeMillis();
    }
    
    public void Contagem(long delta){
        if(iTimeApaga < delta - iTimePassed)
                bApaga = true;
    }
    
    public boolean getApagou(){
        return this.bApaga;
    }
    
}
