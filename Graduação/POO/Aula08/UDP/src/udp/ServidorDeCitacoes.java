package udp;

import java.io.*;
import java.net.*;
import java.util.*;

public class ServidorDeCitacoes {
    /*Datagramas são pacotes de informação trocados pela rede cujo conteúdo, chegada,
      e ordem de chegada não são garantidos, como no caso de sockets (TCP).

      Como o UDP (User Datagram Protocol) não determina um canal persistente,
      ele suporta broadcast e multicast.
      Em Java, broadcast e multicast são conseguidos com a classe MulticastSocket.

      Aplicações: áudio, vídeo, DNS, DHCP, SNMP e RIP.
    */
    
    public static void main(String[] args) throws IOException {
        boolean moreQuotes = true;

        /*Cria um DatagramSocket para receber na porta 4445*/
        DatagramSocket UDP_SOCKET_SERVIDOR = new DatagramSocket(4445);
        /*Faz abertura do arquivo de citações e marca o início da stream*/
        BufferedReader in = new BufferedReader(
                            new InputStreamReader(
                            new FileInputStream("citacoes.txt")));
        in.mark(1);
        
        while (moreQuotes) {
            byte[] BUFFER = new byte[256];

            /*Recebe requisição por uma citação*/
            DatagramPacket UDP_PACOTE = new DatagramPacket(BUFFER, BUFFER.length);
            /*O servidor fica parado nesta linha
              Opcionalmente, pode-se definir quanto é o tempo de espera
              com o método setSoTimeout(int timeout), após o quê uma exceção é lançada 
             */
            UDP_SOCKET_SERVIDOR.receive(UDP_PACOTE);

            /*Lê a citação de um arquivo de citações*/
            String CITACAO = in.readLine();
            if (CITACAO == null) {
                CITACAO = "Não há mais citações";
                break;
            }

            /*Converte a citação em bytes*/
            BUFFER = CITACAO.getBytes();

            /*Lê meta-informações do pacote recebido, para saber a quem responder*/
            InetAddress CLIENTE_ENDERECO = UDP_PACOTE.getAddress();
            int CLIENTE_PORTA = UDP_PACOTE.getPort();

            /*Cria e envia pacote para ser enviado ao cliente como identificado*/
            UDP_PACOTE = new DatagramPacket(BUFFER, BUFFER.length,
                                            CLIENTE_ENDERECO, CLIENTE_PORTA);
            UDP_SOCKET_SERVIDOR.send(UDP_PACOTE);
        }
        UDP_SOCKET_SERVIDOR.close();
    }
}