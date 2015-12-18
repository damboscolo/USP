/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package threads;

/**
 *
 * @author Junio
 */
public class HelloThread extends Thread {
    public void run() {
        System.out.println("Hello from an extended thread!");
    }
}