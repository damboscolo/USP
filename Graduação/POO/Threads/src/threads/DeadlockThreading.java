/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package threads;

/**
 *
 * @author Junio
 */
public class DeadlockThreading extends Thread{
    Amigo amigo1;
    Amigo amigo2;
    DeadlockThreading(Amigo umAmigo, Amigo outroAmigo){
        amigo1 = umAmigo;
        amigo2 = outroAmigo;
    }
    public void run(){
        amigo1.curva_se_a(amigo2);
    }
}
