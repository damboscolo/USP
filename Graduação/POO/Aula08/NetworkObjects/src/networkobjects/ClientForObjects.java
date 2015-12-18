package networkobjects;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;
import networkobjects.Pessoa;

/**
 *
 * @author Junio
 */
public class ClientForObjects {

    public static void main(String[] args) {
        boolean bIsWritting = true;
        Socket CLIENTE_SOCKET = null;
        ObjectOutputStream  ENVIA_OBJETO = null;
        BufferedReader RECEBE = null;
        Scanner scan = new Scanner (System.in);

        try {
            CLIENTE_SOCKET = new Socket("localhost", 8008);

            ENVIA_OBJETO = new ObjectOutputStream(CLIENTE_SOCKET.getOutputStream());
            RECEBE = new BufferedReader(new InputStreamReader(CLIENTE_SOCKET.getInputStream()));

            while (bIsWritting) {
                System.out.println("Digite um nome:");
                String sANome = scan.next();     scan.nextLine();
                System.out.println("Digite uma rua:");                
                String sARua = scan.next();      scan.nextLine();
                System.out.println("Digite um número:");                
                int iANumero = scan.nextInt();   scan.nextLine();

                if(sANome.compareTo("BYE") == 0){
                    bIsWritting = false;
                    ENVIA_OBJETO.writeObject(null);
                } else {
                    Pessoa pAPessoa = new Pessoa(sANome, sARua, iANumero);

                    ENVIA_OBJETO.writeObject(pAPessoa);

                    System.out.println(RECEBE.readLine());
                }
            }

            ENVIA_OBJETO.close();
            RECEBE.close();
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
