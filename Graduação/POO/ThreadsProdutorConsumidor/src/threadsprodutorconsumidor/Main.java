/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package threadsprodutorconsumidor;

/**
 *
 * @author Junio
 */
public class Main {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        Deposito meuDeposito = new Deposito();
        Produtor p = new Produtor(meuDeposito, "Petrobras");
        Consumidor c = new Consumidor(meuDeposito, "Posto da Avenida");
        p.start();
        c.start();
    }
}