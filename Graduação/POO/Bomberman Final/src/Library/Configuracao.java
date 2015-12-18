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
public class Configuracao implements Serializable{
    
    public int autoSaveDelay;
    public int vidasIniciais;
    public boolean modoServidor;
    private static final long serialVersionUID = 2L;
    
    public Configuracao(int autoSaveDelay, int vidasIniciais){
        this.autoSaveDelay = autoSaveDelay;
        this.vidasIniciais = vidasIniciais;
    }
}
