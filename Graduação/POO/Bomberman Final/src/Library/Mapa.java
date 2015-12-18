/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import java.io.IOException;
import java.io.Serializable;

/**
 *
 * @author Eduardo
 */
public class Mapa implements Serializable{

    private int mapa[][];
    
    public Mapa(int mapa[][]) throws IOException{
        this.mapa = mapa;
    }
    
    public int getElementoId(Posicao pos){
        return mapa[pos.getLinha()][pos.getColuna()];
    }
    public int getElementoId(int linha, int coluna){
        return mapa[linha][coluna];
    }
    public void setElementoId(int linha, int coluna, int id){
        this.mapa[linha][coluna] = id;
    }
    public void setElementoId(Posicao pos, int id){
        this.mapa[pos.getLinha()][pos.getColuna()] = id;
    }
    public int getMapaLinhas(){
        return mapa.length;
    }
    public int getMapaColunas(){
        return mapa[0].length;
    }
}
