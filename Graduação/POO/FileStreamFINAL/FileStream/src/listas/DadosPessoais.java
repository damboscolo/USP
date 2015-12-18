package listas;

import java.io.Serializable;

public class DadosPessoais implements Serializable {

    public Endereco endereco;
    public String nome;
    public int idade;

    public DadosPessoais(Endereco endereco, String nome, int idade) {
        this.endereco = endereco;
        this.nome = nome;
        this.idade = idade;
    }

    public String toString() {
        return "DadosPessoais\nNome: " + nome + " - Idade: " + idade + "\n\n" + endereco.toString();
    }
}
