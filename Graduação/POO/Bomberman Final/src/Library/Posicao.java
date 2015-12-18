/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import java.io.Serializable;

/**
 *
 * @author Owner
 */
public class Posicao implements Serializable{
    private int	linha,
                coluna;

    public Posicao(int linha, int coluna){
        this.linha = linha;
        this.coluna = coluna;
    }

    public void SetPosicao(int linha, int coluna){
        this.linha = linha;
        this.coluna = coluna;
    }
    
    public void setLinha(int linha){
        this.linha = linha;
    }

    public int getLinha(){
        return linha;
    }

    public void setColuna(int coluna){
        this.coluna = coluna;
    }

    public int getColuna(){
        return coluna;
    }

    public boolean igual(Posicao posicao){
        return (linha == posicao.getLinha() && coluna == posicao.getColuna());
    }

    public void copia(Posicao posicao){
        setLinha(posicao.getLinha());
        setColuna(posicao.getColuna());
    }
    
    public String toString(){
        return this.linha+","+this.coluna;
    }
}
