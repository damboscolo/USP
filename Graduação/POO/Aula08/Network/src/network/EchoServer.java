/**
 *
 * @author Junio
 */
package network;

import java.io.*;
import java.net.*;

public class EchoServer {

    public static void main(String[] args) {
        boolean bEscutando = true;
        ServerSocket OUVIDO = null;
        
        try {
            OUVIDO = new ServerSocket(8008);
            Socket SERVIDOR_SOCKET;
            /*Este while faz com que o servidor aceita vários clientes, um após o outro */
            while (bEscutando) {

                System.out.println("Escutando...");
                SERVIDOR_SOCKET = OUVIDO.accept();
                System.out.println("Nova conexão recebida...");
                
                BufferedReader RECEBE = new BufferedReader(new InputStreamReader(SERVIDOR_SOCKET.getInputStream()));
                PrintWriter ENVIA = new PrintWriter(new OutputStreamWriter(SERVIDOR_SOCKET.getOutputStream()));

                System.out.println("Servindo...");

                while (true) {
                    String str = RECEBE.readLine();
                    if (str.trim().equals("BYE"))
                        break;                      /*Encerra comunicação com o cliente, e aguarda o próximo*/
                    if (str.trim().equals("CLOSE")){
                        bEscutando = false;         /*Encerra comunicação com o cliente e não aceita mais nenhum (fecha)*/
                        break;      
                    }
                    ENVIA.println("O servidor repete: \"" + str + "\"");
                    ENVIA.flush();
                }
                RECEBE.close();
                ENVIA.close();
                SERVIDOR_SOCKET.close();
            }
            System.out.println("Serviço finalizado...");
            OUVIDO.close();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
