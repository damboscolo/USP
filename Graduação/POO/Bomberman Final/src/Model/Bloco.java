/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Library.Consts;
import Library.Posicao;
import java.awt.Graphics2D;
import java.io.IOException;
import java.io.Serializable;
import javax.swing.JPanel;

/**
 *
 * @author Owner
 */
public class Bloco extends Elemento implements Serializable{
    
    private boolean bInvencible;

    public Bloco(String imagem, Posicao posicao, boolean bInvencible) {
        super(imagem, posicao);
        this.bInvencible = bInvencible;
    }
    
    public boolean getInd(){
        return this.bInvencible;
    }
}
