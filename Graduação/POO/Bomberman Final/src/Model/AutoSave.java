/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Owner
 */
public class AutoSave extends Thread{
    
    private Jogo jogo;
    private int delay;
    
    public AutoSave(Jogo jogo){
        this.jogo = jogo;
        this.delay = 20000;
    }
    
    public void run(){
        while(true){
            try {
                sleep(delay);
            } catch (InterruptedException ex) {
                Logger.getLogger(AutoSave.class.getName()).log(Level.SEVERE, null, ex);
            }
            this.jogo.Salvar();
        }        
    }
    
    public void setDelay(int d){
        delay = d;
    }
}
