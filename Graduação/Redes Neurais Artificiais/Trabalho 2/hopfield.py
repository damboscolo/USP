import numpy as np


class Hopfield():
    def treinar(self, patterns):
        #Pega as medidas da matrix de entrada onde:
        #Linhas = numero de padrões
        #Colunas = tamanho do vetor de entrada
        linhas, colunas = patterns.shape

        #Cria uma matrix de zeroa com o tamanho de uma entrada
        self.weights = np.zeros((colunas, colunas))

        #Aplica para cada padrão o produto vetorial
        #(a partir da regra do produto externo)
        for p in patterns:
            self.weights = self.weights + np.outer(p, p)

        #Zera o pesos das conexões de um neuronio com ele mesmo
        #para evitar auto-retro-alimentação
        np.fill_diagonal(self.weights, 0)

        #Como visto no slide
        #"A razão para usar 1/N como constante de proporcionalidade
        #é simplificar a descrição matemática da recuperação de informação"
        #Cap. 7, pag 66/80
        self.weights = self.weights / linhas

    def lembrar(self, patterns):
        #Vetoriza a funcão de sigmoid para podermos aplicar uma
        #matriz como entrada
        act = np.vectorize(self.activation)
        #Cria uma matriz do mesmo tamanho do padrão, mas cheia de zeros
        oldPattern = np.zeros_like(patterns)

        changed = 0
        iteration = 0
        while(changed <= 1):
            #Guarda valor atual do padrão
            oldPattern = np.copy(patterns)

            #Faz o produto dos pesos com os padrões
            #e aplica a funcão de ativacão
            #Atualizando os pesos dos nodes
            produto = np.dot(patterns, self.weights)
            patterns = act(produto)

            #Compara vetor atual com anteriror
            #para detectar mudança nos valores
            #Pode ser usado também np.array_equal(patterns, oldPattern)
            if (patterns == oldPattern).all():
                changed += 1
            iteration += 1

        #Retorna padrão final encontrado, mais próximo que conseguiu lembrar
        return patterns

    def activation(self, x):
        if x < 0:
            return -1
        return 1
