/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threads;

/**
 *
 * @author Junio
 */
public class ThreadImprimeNumero extends Thread {

    String sNome;

    ThreadImprimeNumero(String sANome) {
        sNome = sANome;
    }

    public void run() {
        try {
            while (true) {
                int iInterval = (int) (2000);
                Thread.sleep(iInterval);
                System.out.println(sNome + "- DORMIU POR " + iInterval/1000f + "s");
            }
        } catch (InterruptedException e) {
            System.out.println("Thread " + sNome + " interrompida.");
        }
    }
}
