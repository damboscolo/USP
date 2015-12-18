/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threads;

/**
 *
 * @author Junio
 */
public class CounterThread extends Thread {
    Counter c;
    public CounterThread(Counter c) {
        this.c = c;
    }

    public void run(){
        /*Cada thread empilha um contexto diferente do método count*/
        /*Mas o dado i manipulado dentro de cada contexto é o mesmo*/
        c.fazerContagem();
    }
}
