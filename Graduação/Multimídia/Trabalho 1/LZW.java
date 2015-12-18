/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trabalho1;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import static java.lang.Byte.parseByte;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author edusig
 */
public class LZW {

    private static String readFile(String filename) throws IOException{
        Path file = Paths.get(filename);
        BufferedReader reader = Files.newBufferedReader(file, Charset.defaultCharset());
        StringBuilder content = new StringBuilder();
        String line = null;
        while((line = reader.readLine()) != null){
            content.append(line);
        }
        return content.toString();
    }
    
    public static void writeFile(byte data[], String filename) throws IOException{
        Path file = Paths.get(filename);
        Files.write(file, data);
    }
    
    public static byte[] serialize(Object obj) throws IOException {
        ByteArrayOutputStream b = new ByteArrayOutputStream();
        ObjectOutputStream o = new ObjectOutputStream(b);
        o.writeObject(obj);
        return b.toByteArray();
    }
    
    public static byte[] intToByteArray (final int integer) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        DataOutputStream dos = new DataOutputStream(bos);
        dos.writeInt(integer);
        dos.flush();
        return bos.toByteArray();
    }
    
    public static byte[] intsToByteArray(List<Integer> ints, int maxbits){
        List buffer;
        
        //Numero de bits necessários para caber todo o input
        int buffersize = maxbits * ints.size();
        //Buffer precisa ser multiplo de 8 para transformar em byte
        while(buffersize % 8 != 0){
            buffersize++;
        }
        //Numero de bytes máximo do arquivo comprimido
        buffersize /= 8;
        
        int n, i, j, k = 0, byteindex = 0, bindex = 0, of = maxbits, nbytes;
        int wof = 0, newof = 0;
        boolean notemp = true;
        byte[] b = new byte[buffersize];
        byte temp = (byte) 0x0000;
        byte[] nb = new byte[4];
        for(i = 0; i < ints.size(); i++){
            n = ints.get(i);
            nb[0] = (byte)((n & 0xFF000000) >> 24);
            nb[1] = (byte)((n & 0x00FF0000) >> 16);
            nb[2] = (byte)((n & 0x0000FF00) >> 8);
            nb[3] = (byte) (n & 0x000000FF);
            if(maxbits % 8 == 0){
                for(j = (int) maxbits/8 - 1; j >= 0 ; j--){
                    b[byteindex] = nb[3-j];
                    byteindex++;
                }
            }else{
                nbytes = (int) Math.floor(maxbits/8);
                for(j = 3 - nbytes; j <= 3 ; j++){
                    if(bindex == 0){//Inicializa as variaveis
                        notemp = true;
                        of = maxbits - (nbytes*8);
                    }

                    bindex = 8 - of; //Quantos espaços ainda estão sobrando no byte
                    wof = maxbits - ((3-j) * 8); //Quantos bits serão escritos nessa passada do for
                    wof = wof > 8 ? 8 : wof; //Limita a 1 byte
                    if(notemp){//Se o temp está vazio começe a preenche-lo
                        temp = (byte) (nb[j] << bindex);//Preenche o byte deixando bindex espaços a direita
                        notemp = false;//Temp não está mais vazio
                    }else if(wof + of < 8){//Se o numero de bits a serem escrito somado com o numero de bits já escritos (of) ainda não completar um byte
                        temp = (byte) ((nb[j] << (bindex - wof)) | temp);//Completa o maximo possivel do byte
                        of += wof;//Soma o numero de bits escritos aos que já estavam escritos
                    }else{//Se o numero de bits a serem escritos completa ou ultrapassa o byte
                        newof = wof - bindex;//O novo offset é calculado usando o numero que será escrito menos o tanto de espaços restantes
                        b[byteindex++] = (byte) ((nb[j] >> newof) | temp);//Adiciona o resto dos bits no byte e coloca no vetor de bytes
                        temp = (byte) (nb[j] << (8 - newof));//Temp recebe os bits restantes, se houverem
                        of = newof;//Offset é atualizado
                    }
                }
            }
        }
        if(temp != 0x0000){
            b[byteindex] = temp;
        }
        return b;
    }
    
    public static byte[] compress(String input) throws IOException{
        int dictsize = 0, i, j, index;
        Map<String, Integer> dictionary = new HashMap<String, Integer>();
        dictionary.put(""+(char)32, dictsize++);
        for(i = 48; i <= 57; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 65; i <= 90; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 97; i <= 122; i++)
            dictionary.put(""+(char)i, dictsize++);
        List result = new ArrayList<Integer>();
        String[] words = input.split(" ");
        for(i = 0; i < words.length; i++){
            String word = words[i];
            if(dictionary.containsKey(words[i])){
                result.add(dictionary.get(word));
            }else{
                for (char ch: word.toCharArray()) {
                    result.add(dictionary.get(""+ch));
                }
                dictionary.put(word, dictsize++);
            }
            result.add(0); //Adiciona o espaço
        }
        
        int maxbits = (int) Math.ceil(Math.log(dictsize)/Math.log(2));
        result.add(0, maxbits);
        byte[] bytes = intsToByteArray(result, maxbits);
        for (byte b : bytes) {
            System.out.println(Integer.toBinaryString(b & 255 | 256).substring(1));
        }
        return bytes;
    }
    
    public static String decompress(byte[] input){
        int dictsize = 0, i, j, index;
        Map<String, Integer> dictionary = new HashMap<String, Integer>();
        dictionary.put(""+(char)32, dictsize++);
        for(i = 48; i <= 57; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 65; i <= 90; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 97; i <= 122; i++)
            dictionary.put(""+(char)i, dictsize++);
        List result = new ArrayList<Integer>();
        return null;
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        if(args.length < 5){
            
            System.out.println("Testando int to bits");
            List<Integer> l = new ArrayList<Integer>();
            for(int i = 1; i < 20; i++){
                l.add(i);
            }
            byte[] bytes = intsToByteArray(l, 5);
            for (byte b : bytes) {
                System.out.println(Integer.toBinaryString(b & 255 | 256).substring(1));
            }
            System.out.println(Arrays.toString(bytes));
            
            return;
        }
        if(args[0].equals("encode") || args[0].equals("decode")){
            if(args.length < 5){
                System.out.println("Usar "+args[0]+" -i arquivo_original.txt -o arquivo_binario.bin");
            }else{
                String infile = args[2];
                String outfile = args[4];
                String input = readFile(infile);
                if(args[0].equals("encode")){
                    byte compressed[] = compress(input);
                    System.out.println("Escrevendo no arquivo");
                    writeFile(compressed, outfile);
                }
            }
        }else{
            System.out.println("Use as funções encode ou decode");
        }
    }
    
}
