/**
 *
 * @author Junio
 */
package network;

import java.io.*;
import java.net.*;
/**
 *
 * @author Junio
 */
public class EchoServerThread extends Thread {

    private Socket SERVIDOR_SOCKET = null;

    public EchoServerThread(Socket umCLIENTE) {
        this.SERVIDOR_SOCKET = umCLIENTE;
    }

    public void run() {
        try {
            /* Não é feito aqui mais.
             ServerSocket OUVIDO = new ServerSocket(8008);
             */
            while (true) {
                /* Também não é mais necessário
                System.out.println("Escutando...");
                Socket SERVIDOR_SOCKET = OUVIDO.accept();
                */
                BufferedReader RECEBE = new BufferedReader(new InputStreamReader(SERVIDOR_SOCKET.getInputStream()));
                PrintWriter ENVIA = new PrintWriter(new OutputStreamWriter(SERVIDOR_SOCKET.getOutputStream()));

                System.out.println("Servindo um cliente...");

                while (true) {
                    String str = RECEBE.readLine();

                    ENVIA.println("A thread servidora repete: \"" + str + "\"");
                    ENVIA.flush();

                    if (str.trim().equals("BYE"))
                        break;
                }
                RECEBE.close();
                ENVIA.close();
                SERVIDOR_SOCKET.close();
            }
        } catch (Exception e) {
        }
    }
}
