/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package networkobjects;

import java.io.Serializable;

/**
 *
 * @author Junio
 */
public class Endereco implements Serializable{
    String sRua;
    int iNumero;
    public Endereco(String sARua, int iANumero){
       sRua = sARua;
       iNumero = iANumero;
    }
}
