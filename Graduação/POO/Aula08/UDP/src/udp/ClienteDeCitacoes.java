package udp;

import java.io.*;
import java.net.*;
import java.util.*;

public class ClienteDeCitacoes {
    public static void main(String[] args) throws IOException {      
        InetAddress SERVIDOR_ENDERECO = InetAddress.getByName("localhost");
        int SERVIDOR_PORTA = 4445;
        byte[] BUFFER = new byte[256];

        /*Diferente do TCP (classe Socket), um DatagramSocket não estabelece um
          canal persistente, portanto não recebe nem ip, nem porta*/
        DatagramSocket UDP_SOCKET_CLIENTE = new DatagramSocket();

        /*Cria e envia pacote vazio, apenas para receber requisitar a citação
          enviando meta-informações para envio da resposta*/
        DatagramPacket UDP_PACOTE = new DatagramPacket(BUFFER, BUFFER.length,
                                             SERVIDOR_ENDERECO, SERVIDOR_PORTA);
        UDP_SOCKET_CLIENTE.send(UDP_PACOTE);

        /*Recebe pacote com a citação*/
        UDP_PACOTE = new DatagramPacket(BUFFER, BUFFER.length);
            /*O cliente fica parado nesta linha*/
        UDP_SOCKET_CLIENTE.receive(UDP_PACOTE);

	/*Lê o pacote, de 0 a getLength()*/
        String CITACAO_RECEBIDA = new String(UDP_PACOTE.getData(),
                                             0,UDP_PACOTE.getLength());
        System.out.println("Citacao recebida: " + CITACAO_RECEBIDA);

        UDP_SOCKET_CLIENTE.close();
    }
}
