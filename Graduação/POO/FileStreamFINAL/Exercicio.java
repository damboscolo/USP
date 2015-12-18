/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package exercicios;

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 *
 * @author edusig
 */
public class Exercicio {
   
    public Exercicio() throws FileNotFoundException, IOException{
        byte bytes[] = new byte[64];
        String nome = "Eduardo";
        bytes = nome.getBytes();
        int data;
        FileOutputStream fos = new FileOutputStream("Teste.txt");
        ByteArrayInputStream bais = new ByteArrayInputStream(bytes);
        while((data=bais.read())!=-1){
            char ch = (char)data;
            fos.write(ch);
        }
        fos.flush();
        fos.close();
        bais.close();
    }
}
