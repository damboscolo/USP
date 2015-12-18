/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threadsprodutorconsumidor;
/**
 *
 * @author Junio
 */
public class Produtor extends Thread {
    private Deposito deposito;
    private String sNome;
    public Produtor(Deposito c, String sANome) {
        deposito = c;
        sNome = sANome;
    }

    public void run() {
        for (int i = 0; i < 10; i++)
            deposito.put(sNome, i);
    }
}