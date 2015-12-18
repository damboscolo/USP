import numpy as np
import matplotlib.pyplot as plt
from hopfield import Hopfield


#Le arquivo de padrão e retorna o conteudo
def readPatterns(filename):
    #lista de listas contendo todos os valores
    train = []
    #lista temporaria da linha
    line = []
    with open(filename, 'r') as letters:
        while True:
            #Lê a linha e remova o \n
            letter = letters.readline().rstrip()
            #Quando acaba as linhas para o loop
            if not letter:
                break
            #Para cada digito, transforma em inteiro e adiciona em na lista
            line = [int(x) for x in letter]
            #Adiciona essa lista na matriz de valores
            train.append(line)
    #Transforma a lista de listas em matriz do numpy
    m = np.array(train)
    return m


#Converte valores de 0-1 para -1 a 1
def fix_values(pattern):
    pattern = pattern * 2
    pattern = pattern - 1
    return pattern


#Exibe uma janela contendo a imagem do padrão
def display(pattern):
    plt.imshow(pattern, cmap=plt.cm.binary, interpolation='nearest')
    plt.show()


if __name__ == '__main__':

    hop = Hopfield()

    #Le arquivos de treinamento e teste
    train_patterns = readPatterns("train_letters_4.txt")
    test_patterns = readPatterns("test_letters_4.txt")

    #Mostra imagens dos padrões de entrada para memorização
    #for i in range(len(train_patterns)):
    #    display(train_patterns[i].reshape(10, 10))

    #Mostra imagens dos padrões para teste da rede
    #for i in range(len(test_patterns)):
    #    display(test_patterns[i].reshape(10, 10))

    train_patterns = fix_values(train_patterns)
    test_patterns = fix_values(test_patterns)

    #

    print("Treinamento")

    #Treina a rede
    hop.treinar(train_patterns)

    #

    print("Verificando Aprendizado")

    #Guarda em pattern os resultados da tentativa de lembrança
    # a partir dos dados de treinamento.
    #Isso serve para verificar que a rede aprendeu.
    pattern = [hop.lembrar(x) for x in train_patterns]

    #Mostra a saida resultante das lembranças
    #Verificar se a rede aprendeu
    for i in pattern:
        display(i.reshape(10, 10))

    #

    print("Teste com ruido")

    #Guarda em pattern os resultados da tentativa de lembraça a partir dos teste.
    #Com isso verifica-se que a rede consegue lembrar mesmo com ruido na imagem.
    pattern = [hop.lembrar(x) for x in test_patterns]

    #Mostra a saida resultante das lembranças
    for i in pattern:
        display(i.reshape(10, 10))
