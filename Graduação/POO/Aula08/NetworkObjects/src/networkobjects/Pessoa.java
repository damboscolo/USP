package networkobjects;

import java.io.Serializable;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Junio
 */
public class Pessoa implements Serializable{
    String sNome;
    Endereco eEndereco;

    public Pessoa(String sANome, String sARua, int iANumero){
        sNome = sANome;
        eEndereco = new Endereco(sARua, iANumero);
    }
}
