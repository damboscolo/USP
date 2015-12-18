package listas;

import java.io.Serializable;

public class Endereco implements Serializable {

    public int numero;
    public String UF;
    public String Cidade;
    public String Rua;
    public String Bairro;

    public Endereco(int numero, String UF, String Cidade, String Rua, String Bairro) {
        this.numero = numero;
        this.UF = UF;
        this.Cidade = Cidade;
        this.Rua = Rua;
        this.Bairro = Bairro;
    }

    public String toString() {
        return "Endereço\nRua: " + getRua()
                + " - UF: " + getUF()
                + " - Cidade: " + getCidade()
                + " - Numero: " + getNumero();
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getUF() {
        return UF;
    }

    public void setUF(String UF) {
        this.UF = UF;
    }

    public String getRua() {
        return Rua;
    }

    public void setRua(String Rua) {
        this.Rua = Rua;
    }

    public String getCidade() {
        return Cidade;
    }

    public void setCidade(String Cidade) {
        this.Cidade = Cidade;
    }

    public String getBairro() {
        return Bairro;
    }

    public void setBairro(String Bairro) {
        this.Bairro = Bairro;
    }
}
