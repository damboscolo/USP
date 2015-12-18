package filestream;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;

public class FileStream {
    
    public static void main(String[] args) throws FileNotFoundException, IOException {
        Exercicios ex = new Exercicios();
        ex.ex1mostraArquivos("D:\\3) Programas");
        /*
         ex.ex2arquivosExe("D:\\3) Programas");        
         ex.ex3LineReader("line.txt");
         ex.ex4zipObject("zipado.rar");        
         ex.ex6trocaPalavra("C:\\Users\\Daniele\\Desktop\\texto.txt");
         * */
    }
}
