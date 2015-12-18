/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package threads;

import java.util.ArrayList;

/**
 *
 * @author Junio
 */
public class HelloRunnable extends ArrayList implements Runnable {

    public void run() {
        System.out.println("Hello from a runnable thread!");
    }
}