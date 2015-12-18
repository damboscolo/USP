/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package threads;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Junio
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        //try {
        //////////////////////////////////////////////////////////////////
        /*Exemplo de criação básica de threads*/
        //(new HelloThread()).start();
        //(new Thread(new HelloRunnable())).start();

        /*Exemplo de thread com intervalos de sleep*/
        //SleepMessages sMsgs = new SleepMessages();
        //sMsgs.start();
        //////////////////////////////////////////////////////////////////        
        /*Exemplo de execução em paralelo com interrupção*/
        /*        ThreadImprimeNumero t1 = new ThreadImprimeNumero("Primeira*********");
         ThreadImprimeNumero t2 = new ThreadImprimeNumero("Segunda----------");
         ThreadImprimeNumero t3 = new ThreadImprimeNumero("Teceira++++++++++");

         t1.start();
         t2.start();
         t3.start();
         try {
         BufferedReader LEITOR_ENTRADA_PADRAO = new BufferedReader(new InputStreamReader(System.in));
         String userInput;
         while (true) {
         userInput = LEITOR_ENTRADA_PADRAO.readLine();
         if (userInput.compareTo("BYE") == 0) {
         break;
         }
         System.out.println("Voce digitou " + userInput);
         }
         } catch (IOException ex) {
         Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
         }

         t1.interrupt();
         t2.interrupt();
         t3.interrupt();
         System.out.println("Threads interrompidas");
        */
        //////////////////////////////////////////////////////////////////        
        /*Exemplo de threads que compartilham o mesmo dado*/
        /*
        Counter cSemConcorrencia = new Counter();
        cSemConcorrencia.fazerContagem();
        cSemConcorrencia.fazerContagem();
        System.out.println("Variável i sem concorrencia: " + cSemConcorrencia.getContador());

        Counter c = new Counter();
        CounterThread ct1 = new CounterThread(c);
        CounterThread ct2 = new CounterThread(c);
        ct1.start();
        ct2.start();

        try {
            //Faz com que a thread main fique parada aqui, 
            //até que a thread ct1 - já em execução, após start - termine
            ct1.join();
            //Idem
            ct2.join();
        } catch (InterruptedException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.out.println("Variável i com concorrencia: " + c.getContador() + ", mas o valor esperado era " + cSemConcorrencia.getContador());
        */
        //////////////////////////////////////////////////////////////////        
        /*Deadlock exemplo*/
        /*
         Amigo jose = new Amigo("Jose");
         Amigo joao = new Amigo("Joao");
         DeadlockThreading dtTemp1 = new DeadlockThreading(jose, joao);
         DeadlockThreading dtTemp2 = new DeadlockThreading(joao, jose);
         dtTemp1.start();
         dtTemp2.start();
         */
    }
}
