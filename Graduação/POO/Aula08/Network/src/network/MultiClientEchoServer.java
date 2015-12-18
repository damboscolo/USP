/**
 *
 * @author Junio
 */
package network;

import java.net.*;
import java.io.*;

/**
 *
 * @author Junio
 */
public class MultiClientEchoServer {

    public static void main(String[] args){
        
        boolean bEscutando = true;
        ServerSocket OUVIDO = null;

        try {
            System.out.println("Escutando múltiplos clientes...");
            OUVIDO = new ServerSocket(8008);

            while (bEscutando) {
                Socket SERVIDOR_SOCKET = OUVIDO.accept();

                EchoServerThread threadServidora = new EchoServerThread(SERVIDOR_SOCKET);
                
                threadServidora.start();
            }
            
            OUVIDO.close();
            
        } catch (IOException e) {
            System.err.println("Nao pude escutar na porta: " + 8008);
            System.exit(-1);
        }
    }
}
