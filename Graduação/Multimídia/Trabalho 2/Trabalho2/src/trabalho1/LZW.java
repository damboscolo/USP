/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trabalho1;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
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
        String line;
        while((line = reader.readLine()) != null){
            content.append(line);
        }
        return content.toString();
    }
    
    public static byte[] readBinaryFile(String filename) throws IOException{
        Path file = Paths.get(filename);
        return Files.readAllBytes(file);
    }
    
    public static void writeFile(String input, String filename) throws IOException{
        Path file = Paths.get(filename);
        List<String> lines = new ArrayList<>();
        lines.add(input);
        Files.write(file, input.getBytes());
    }
    
    public static void writeBinaryFile(byte data[], String filename) throws IOException{
        Path file = Paths.get(filename);
        Files.write(file, data);
    }
    
    public static byte[] intsToByteArray(List<Integer> ints, int maxbits){
        //Numero de bits necessários para caber todo o input
        int buffersize = maxbits * (ints.size());
        //Buffer precisa ser multiplo de 8 para transformar em byte
        while(buffersize % 8 != 0){
            buffersize++;
        }
        //Numero de bytes máximo do arquivo comprimido
        buffersize /= 8;
        //O primeiro numero da lista é o numero maximo de bits, como ele será escrito como inteiro adicionamos 4 bytes
        buffersize += 4;
        
        int n, i, j, byteindex = 0, bindex = 0, of = maxbits, nbytes, wof, newof;
        boolean notemp = true;
        byte[] b = new byte[buffersize];
        byte[] nb = new byte[4];
        byte temp = (byte) 0x0000;
        nbytes = (int) Math.floor(maxbits/8); //Numero de bytes completos
        
        
        //Separa o maxbits em um array de 4 bytes
        nb[0] = (byte)((maxbits & 0xFF000000) >> 24);
        nb[1] = (byte)((maxbits & 0x00FF0000) >> 16);
        nb[2] = (byte)((maxbits & 0x0000FF00) >> 8);
        nb[3] = (byte) (maxbits & 0x000000FF);
        
          //Pode ser feito assim
          //Separa o maxbits em um array de 4 bytes
//        ByteBuffer bytebuffer = ByteBuffer.allocate(4);
//        bytebuffer.putInt(maxbits);
//        nb = bytebuffer.array();

        //Escreve o numero máximo de bits como inteiro no byte array
        for(j = 0; j <= 3; j++){
            b[byteindex++] = nb[j];
        }
        
        for(i = 0; i < ints.size(); i++){

            n = ints.get(i);
            //Separa o inteiro em um array de 4 bytes
            nb[0] = (byte)((n & 0xFF000000) >> 24);
            nb[1] = (byte)((n & 0x00FF0000) >> 16);
            nb[2] = (byte)((n & 0x0000FF00) >> 8);
            nb[3] = (byte) (n & 0x000000FF);
            
            //Se for multiplo de 8 bits já escreve direto
            if(maxbits % 8 == 0){
                for(j = (int) maxbits/8 - 1; j >= 0 ; j--){
                    //pode ser feito assim
                    //for(j = 4 - nbytes; j <= 3 ; j++)
                    //b[byteindex] = nb[j];
                    b[byteindex] = nb[3-j];
                    byteindex++;
                }
//                
//                //ERRADO!!! Exemplo: 12 bits eh multiplo de 4, mas soh os 4 bits menos significativos serao escritos
//            }else if(maxbits % 4 == 0){
//                if(i % 2 == 0){
//                    b[byteindex] = (byte) (nb[3] << 4);
//                }else{
//                    b[byteindex] = (byte) (b[byteindex] | nb[3]);
//                    byteindex++;
//                }
                
            }else{
                //Para "puxar" os bits para esquerda começamos do menor valor não 0
                for(j = 3 - nbytes; j <= 3 ; j++){
                    if(bindex == 0){//Inicializa as variaveis
                        notemp = true;
                        of = maxbits - (nbytes*8);
                    }
                    
                    //Quantos espaços ainda estão sobrando no byte
                    bindex = 8 - of;
                    //Quantos bits serão escritos nessa passada do for
                    wof = maxbits - ((3-j) * 8);
                    //Limita a 1 byte
                    wof = wof > 8 ? 8 : wof;
                    //Se o temp está vazio começe a preenche-lo
                    if(notemp){
                        //Preenche o byte deixando bindex espaços a direita
                        temp = (byte) (nb[j] << bindex);
                        //Temp não está mais vazio
                        notemp = false;
                    //Se o numero de bits a serem escrito somado com o numero de bits já escritos (of) ainda não completar um byte
                    }else if(wof + of < 8){
                        //Completa o maximo possivel do byte
                        temp = (byte) ((nb[j] << (bindex - wof)) | temp);
                        //Soma o numero de bits escritos aos que já estavam escritos
                        of += wof;
                    //Se o numero de bits a serem escritos completa ou ultrapassa o byte
                    }else{
                        //O novo offset é calculado usando o numero que será escrito menos o tanto de espaços restantes
                        newof = wof - bindex;
                        //Adiciona o resto dos bits no byte e coloca no vetor de bytes
                        
                        //Essa manipulacao abaixo serve para limpar os 1s adicionados no comeco do byte
                        //faz a mesma coisa que >>> deveria fazer(soh q >>> nao funciona)
                        byte rightShiftedByte = (byte)(nb[j] >> newof);
                        byte mask = 0x1;
                        for (int x=7; x>newof; x--) {
                            mask = (byte)(mask << 1);
                            mask += 1;
                        }         
                        rightShiftedByte = (byte)(rightShiftedByte & mask);
                        
                        b[byteindex++] = (byte) (rightShiftedByte | temp);
                        //Temp recebe os bits restantes, se houverem
                        temp = (byte) (nb[j] << (8 - newof));
                        //Offset é atualizado
                        of = newof;
                    }
                }
            }
        }
        if(byteindex < buffersize)
            b[byteindex] = temp;
        return b;
    }
    
    public static List<Integer> bitsToIntArray(byte[] bytes){
        List<Integer> result;
        result = new ArrayList<>();
        int i, j, maxbits;
        
        byte[] temp = new byte[4];
        //Pega o valor do maxbits em byte
        for(i = 0; i < 4; i++){
            temp[i] = bytes[i];
        }
        //Converte os 4 bytes para um valor inteiro.
        maxbits = ByteBuffer.wrap(temp).getInt();
        
        int bitIndex = maxbits-1;
        int code = 0;
        for ( i = 4; i < bytes.length; i++) {
            byte b = bytes[i];
            int mask = 128; // Corresponde a 1000 0000 em binario
            for (j = 0; j < 8; j++) {
                if((b & mask) == mask) {
                    code += Math.pow(2, bitIndex);
                }
                mask = (mask >>> 1);

                if (bitIndex == 0) {
                    result.add(code);
                    code = 0;
                    bitIndex = maxbits-1;
                } else {
                    bitIndex--;
                }
            }                   
        }
        
        return result;
    }
    
    public static byte[] dynamicIntsToByteArray(List<Integer> ints){
        return null;
    }
    
    public static List<Integer> dynamicBitsToIntArray(byte[] bytes){
        return null;
    }
    
    public static Map<String, Integer> initializeDictionary(){
        int dictsize = 0, i;
        //Utiliza-se a interface map que define uma estrutura para ligar chave e valor.
        Map<String, Integer> dictionary;
        //HashMap implementa a interface Map e não permite valores repetidos de chave.
        dictionary = new HashMap<>();
        dictionary.put(""+(char)32, dictsize++);
        for(i = 48; i <= 57; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 65; i <= 90; i++)
            dictionary.put(""+(char)i, dictsize++);
        for(i = 97; i <= 122; i++)
            dictionary.put(""+(char)i, dictsize++);
        return dictionary;
    }
    
    public static List<String> initializeDictionary(boolean list){
        int i;
        //Utiliza-se a interface map que define uma estrutura para ligar chave e valor.
        List<String> dictionary;
        //HashMap implementa a interface Map e não permite valores repetidos de chave.
        dictionary = new ArrayList<>();
        dictionary.add(""+(char)32);
        for(i = 48; i <= 57; i++)
            dictionary.add(""+(char)i);
        for(i = 65; i <= 90; i++)
            dictionary.add(""+(char)i);
        for(i = 97; i <= 122; i++)
            dictionary.add(""+(char)i);
        return dictionary;
    }
    
    public static byte[] compress(String input, boolean dynamic) throws IOException{
        int dictsize, i;
        Map<String, Integer> dictionary = initializeDictionary();
        dictsize = dictionary.size();
        List<Integer> result;
        result = new ArrayList<>();
        String[] words = input.split(" ");
        for(i = 0; i < words.length; i++){
            String word = words[i];
            if(word.equals("")){
                result.add(0);
            }else if(dictionary.containsKey(word)){
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
        byte[] bytes = intsToByteArray(result, maxbits);
        return bytes;
    }
    
    public static String decompress(byte[] input, boolean dynamic){
        int i;
        List<String> dictionary = initializeDictionary(true);
        List<Integer> codes;
        StringBuilder result = new StringBuilder();
        StringBuilder temp = new StringBuilder();
        codes = bitsToIntArray(input);
        i = 0;
        for(int code : codes){
            if(code == 0){
                result.append(temp);
                result.append(dictionary.get(code));
                //Se juntar mais do que 1 codigo adiciona no dicionario
                if(i > 1)
                    dictionary.add(temp.toString());
                i = 0;
                temp.setLength(0);
            }else{
                temp.append(dictionary.get(code));
                i++;
            }
        }
        result.deleteCharAt(result.lastIndexOf(" "));
        return result.toString();
    }
    
    /**
     * @param args the command line arguments
     * @throws java.io.IOException
     */
    public static void main(String[] args) throws IOException {
        if(args.length < 5){
            System.out.println("Para codificar e decodificar de maneira estatica:");
            System.out.println("Usar encode -i arquivo_original.txt -o arquivo_binario.bin");
            System.out.println("Ou decode -i arquivo_binario.bin -o arquivo_descomprimido.txt\n");
            System.out.println("Para codificar e decodificar de maneira dinamica:");
            System.out.println("Usar encode -i arquivo_original.txt -o arquivo_binario.bin -d");
            System.out.println("Ou decode -i arquivo_binario.bin -o arquivo_descomprimido.txt -d");
            return;
        }
        
        String infile = args[2];
        String outfile = args[4];
        boolean dynamic = args.length == 6;
        
        switch (args[0]) {
            case "encode":
                String input = readFile(infile);
                byte compressed[] = compress(input, dynamic);
                writeBinaryFile(compressed, outfile);
                break;
            case "decode":
                byte[] b = readBinaryFile(infile);
                String output = decompress(b, dynamic);
                writeFile(output, outfile);
                break;
            default:
                System.out.println("Use as funções encode ou decode");
                break;
        }
    }
}
