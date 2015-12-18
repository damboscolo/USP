/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threadsprodutorconsumidor;
/**
 *
 * @author Junio
 */
public class Consumidor extends Thread {
    private Deposito deposito;
    private String sNome;
    public Consumidor(Deposito c, String sANome) {
        deposito = c;
        sNome = sANome;
    }

    public void run() {
        int value = 0;
        for (int i = 0; i < 10; i++)
            value = deposito.get(sNome);
    }
}