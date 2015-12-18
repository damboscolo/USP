/**
 *
 * @author Junio
 */
package network;

/**
 *
 * @author Junio
 */
import java.io.*;
import java.net.*;

public class EchoClient {

    public static void main(String[] args) {

        Socket CLIENTE_SOCKET = null;
        PrintWriter ENVIA = null;
        BufferedReader RECEBE = null;

        try {
            /*O cliente precisa saber a porta do servidor
              Quando o cliente for executado, ele receberá uma porta do sistema operacional,
              e quando o servidor receber a conexão, ele receberá o número da porta do cliente.*/
            CLIENTE_SOCKET = new Socket("localhost", 8008);

            ENVIA = new PrintWriter(CLIENTE_SOCKET.getOutputStream(), true);
            RECEBE = new BufferedReader(new InputStreamReader(CLIENTE_SOCKET.getInputStream()));

            BufferedReader LEITOR_ENTRADA_PADRAO = new BufferedReader(new InputStreamReader(System.in));

            String userInput;
            while(true){
                userInput = LEITOR_ENTRADA_PADRAO.readLine();
                ENVIA.println(userInput);                
                if((userInput.compareTo("BYE") == 0) || (userInput.compareTo("CLOSE") == 0))
                    break;
                System.out.println(RECEBE.readLine());             
            }
            ENVIA.close();
            RECEBE.close();
            LEITOR_ENTRADA_PADRAO.close();
            CLIENTE_SOCKET.close();

        } catch (UnknownHostException e) {
            System.err.println("Endereço de rede incorreto.");
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Endereço correto, mas nenhuma resposta.");
            System.exit(1);
        }
    }
}
