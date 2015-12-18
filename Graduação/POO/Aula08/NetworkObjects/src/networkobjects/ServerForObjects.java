package networkobjects;

import java.io.*;
import java.net.*;
import java.util.ArrayDeque;
import java.util.ArrayList;

/**
 *
 * @author Junio
 */
public class ServerForObjects {

    public static void main(String[] args) {
        boolean bEscutando = true;
        ServerSocket OUVIDO = null;
        ArrayList<Pessoa> alPessoa = new ArrayList<Pessoa>();

        try {
            OUVIDO = new ServerSocket(8008);
            while (bEscutando) {

                System.out.println("Escutando...");
                Socket SERVIDOR_SOCKET = OUVIDO.accept();

                ObjectInputStream RECEBE_OBJETO = new ObjectInputStream(SERVIDOR_SOCKET.getInputStream());
                PrintWriter ENVIA = new PrintWriter(new OutputStreamWriter(SERVIDOR_SOCKET.getOutputStream()));

                System.out.println("Servindo...");

                while (true) {
                    Object oTemp = RECEBE_OBJETO.readObject();

                    if (oTemp != null) {
                        Pessoa pAPessoa = (Pessoa) oTemp;
                        alPessoa.add(pAPessoa);

                        ENVIA.println("O servidor diz: \"" + pAPessoa.sNome + " recebido(a). Manda mais.\"");
                        ENVIA.flush();
                    } else {
                        RECEBE_OBJETO.close();
                        ENVIA.close();
                        SERVIDOR_SOCKET.close();
                        break;
                    }
                }
                for (Pessoa p : alPessoa) {
                    System.out.println(p.sNome + ", " + p.eEndereco.sRua + ", " + p.eEndereco.iNumero);
                }

            }
            OUVIDO.close();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
