/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import java.awt.Graphics;
import java.awt.Image;
import java.io.Serializable;

/**
 *
 * @author Owner
 */
public class Sprite implements Serializable{
    
    private Image imagem;
    
    public Sprite(Image imagem){
        this.imagem = imagem;
    }
    
    public int getWidth(){
        return imagem.getWidth(null);
    }
    public int getHeight(){
        return imagem.getHeight(null);
    }
    public void draw(Graphics g, int x, int y){
        g.drawImage(imagem, x, y, null);
    }
    
}
