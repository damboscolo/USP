/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Model;

import Library.Consts;
import Library.Posicao;
import Library.SpriteLoader;
import java.awt.Graphics2D;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import javax.swing.ImageIcon;
import javax.swing.JPanel;

/**
 *
 * @author Junio
 */
public abstract class Elemento implements Serializable {
    protected Posicao pPosicao;
    protected Sprite sprite;

    protected Elemento(String imagem, Posicao posicao) {
        this.pPosicao = posicao;
        this.sprite = SpriteLoader.get().getSprite(imagem);
    }
    public void SetPosicao(int linha, int coluna){
        pPosicao.setLinha(linha);
        pPosicao.setColuna(coluna);
    }
    
    public void desenha(Graphics2D g){
        sprite.draw(g, (int)pPosicao.getColuna() * Consts.SIZE, (int)pPosicao.getLinha() * Consts.SIZE);
    }
    
    public void logica(){}
    
    public Posicao getPosicao(){
        return this.pPosicao;
    }
    
    public void setSprite(String imagem){
        File checkImagem = new File(imagem);
        if(checkImagem.exists())
            this.sprite = SpriteLoader.get().getSprite(imagem);
        else
            System.out.println("Arquivo inválido");
    }
    
    public void setSprite(File checkImagem){
        if(checkImagem.exists())
            this.sprite = SpriteLoader.get().getSprite(checkImagem.getName());
        else
            System.out.println("Arquivo inválido");
    }
}
