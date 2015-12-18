/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package threads;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Junio
 */
public class SleepMessages extends Thread{
    int iMessages;
    SleepMessages(){
        iMessages = 0;
    }
    public void run(){
        String importantInfo[] = {
            "Hoje é segunda-feira",
            "O dia está claro",
            "O jogo de futebol comeca as 21:00",
            "Qual filme vai passar hoje?"
        };
        long lInterval;
        for (int i = 0; i < importantInfo.length; i++) {
            try {
                lInterval = (long) (Math.random() * 1000);
                System.out.println("Espera de " + lInterval + " ms");
                Thread.sleep(lInterval);
            } catch (InterruptedException ex) {
                Logger.getLogger(SleepMessages.class.getName()).log(Level.SEVERE, null, ex);
            }
            //Print a message
            System.out.println(importantInfo[i]);
            iMessages++;
        }
    }
}