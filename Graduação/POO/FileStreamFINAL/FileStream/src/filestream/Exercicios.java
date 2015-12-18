/*
 * Alunos:
 * Daniele Boscolo N USP : 7986625
 * Eduardo Sigrist Ciciliato N USP: 7986542
 */
package filestream;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.RandomAccessFile;
import java.io.Reader;

/**
 *
 * @author Daniele
 */
public class Exercicios {

    //1
    public void ex1mostraArquivos(String sPath) {
        File file = new File(sPath);
        File[] listaFiles = file.listFiles();
        for (int i = 0; i < listaFiles.length; i++) {
            if (listaFiles[i].isDirectory()) {
                ex1mostraArquivos(listaFiles[i].getPath());
            } else {
                System.out.println(listaFiles[i].getName());
            }
        }
    }

    //2
    public void ex2arquivosExe(String sPath) {
        File file = new File(sPath);
        Filtro filtro = new Filtro();
        File[] listaFiles = file.listFiles(filtro);
        for (int i = 0; i < listaFiles.length; i++) {
            if (listaFiles[i].isDirectory()) {
                ex2arquivosExe(listaFiles[i].getPath());
            } else {
                System.out.println(listaFiles[i].getName());
            }
        }
    }

    //3
    public void ex3LineReader(String sPath) {
        try {
            FileReader filereader = new FileReader(sPath);
            LineNumberReader lineNumber = new LineNumberReader((Reader) filereader);

            String sTemp = null;
            for (int i = 0; i < 10; i++) {
                lineNumber.setLineNumber(i);
                sTemp = lineNumber.readLine();
            }

            if (sTemp == null) {
                System.out.println("Não possui linha 10");
            } else {
                System.out.println(sTemp + "  Linha 10 foi lida");
            }

        } catch (Exception e) {
            System.out.println("Nao foi possivel encontrar o arquivo.");
        }
    }

    //4
    public void ex4zipObject(String sPath) {
        try {
            File fTemp = new File(sPath);
            if (fTemp.exists()) {
                fTemp.createNewFile();
            }
            listas.DadosPessoais dados = new listas.DadosPessoais(new listas.Endereco(59, "SP", "Araraquara", "Rua 9 de julho", "Vila Xavier"), "Daniele", 19);

            FileOutputStream canoOut = new FileOutputStream(sPath);
            ObjectOutputStream serializador = new ObjectOutputStream(canoOut);
            serializador.writeObject(dados);
            serializador.close();
            canoOut.close();
            FileInputStream canoIn = new FileInputStream(sPath);
            ObjectInputStream deserializador = new ObjectInputStream(canoIn);
            dados = (listas.DadosPessoais) deserializador.readObject();
            System.out.println(dados);
        } catch (Exception e) {
            System.out.println("Erro.");;
        }
    }
    
    //5
    public void ex5ByteArrayInputSream() throws FileNotFoundException, IOException{
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

    //6
    public void ex6trocaPalavra(String sAFile) throws FileNotFoundException, IOException {
        int i = 0;
        RandomAccessFile raf = new RandomAccessFile(sAFile, "rw");
        String linha = new String();
        raf.seek(i);
        //while (raf.readBoolean()) {
        while (raf.getFilePointer() < raf.length()) {
            long pos = raf.getFilePointer();

            linha = raf.readLine();
            System.out.println(linha);
            linha = linha.replaceAll("muito", "pouco");
            System.out.println(linha);
            raf.seek(pos);
            raf.writeBytes(linha);
        }
        /*Lê linha por linha*/
        raf.seek(0);
        while (raf.getFilePointer() < raf.length()) {
            System.out.println(raf.readLine());
        }
        raf.close();
    }
}
