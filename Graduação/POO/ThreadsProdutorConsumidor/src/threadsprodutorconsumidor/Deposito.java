/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threadsprodutorconsumidor;
/**
 *
 * @author Junio
 */
public class Deposito {
    private int conteudo;
    private boolean disponibilidade = false;

    public synchronized void put(String who, int value) {
        if (disponibilidade == true) {
            try {
                wait(); /*faz com que se aguarde até o término de um consumo no método get*/
            } catch (InterruptedException e) { }
        }
        conteudo = value;
        disponibilidade = true;
        System.out.format("Produtor %s lançou: %s%n", who, conteudo);

        /*o que foi produzido só pode ser consumido após o término completo de put*/
        /*a última coisa feita aqui então é a notificação*/
        notify();
    }
    
    public synchronized int get(String who) {
        if (!disponibilidade) {
            try {
                wait(); /*faz com que se aguarde até o término de uma produção no método put*/
            } catch (InterruptedException e) { }
        }
        disponibilidade = false;
        System.out.format("Consumidor %s pegou: %s%n", who, conteudo);

        /*uma nova produção só pode ser realizada após o término completo de get*/
        /*a última coisa feita aqui então é a notificação*/
        notify();
        return conteudo;
    }
}