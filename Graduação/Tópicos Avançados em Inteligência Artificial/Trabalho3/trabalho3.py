import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import random
import math
from copy import deepcopy
from time import time
from datetime import timedelta
from multiprocessing import Pool
import sys
sys.setrecursionlimit(10000)

class Vertex:
    def __init__(self,key):
        self.id = key
        self.degree = 0
        self.connectedTo = set([])
        self.possibleNbrs = []

    def addNeighbor(self, nbr):
        if nbr not in self.connectedTo:
            self.degree = self.degree + 1
            self.connectedTo.add(nbr)

    def removeNeighbor(self, nbr, verbose=True):
        self.degree = self.degree - 1
        if nbr in self.getConnections():
            self.connectedTo.remove(nbr)
            if verbose is True:
                print 'Removido {} <-> {}'.format(self.id, nbr.getId())
            nbr.removeNeighbor(self.id, verbose=verbose)

    def __str__(self):
        return str(self.id) + ' conectado com: ' + str([x.id for x in self.connectedTo])

    def __repr__(self):
        return '{} '.format(self.id)

    def getConnections(self):
        return self.connectedTo

    def getId(self):
        return self.id

    def getWeight(self,nbr):
        return self.connectedTo[nbr]

class Graph:
    def __init__(self):
        self.vertList = {}
        self.numVertices = 0
        self.linkList = set([])

    def addVertex(self,key):
        self.numVertices = self.numVertices + 1
        newVertex = Vertex(key)
        self.vertList[key] = newVertex
        return newVertex

    def removeVertex(self,key):
        self.numVertices = self.numVertices - 1
        for v in self.vertList.values():
            if key in v.getConnections():
                v.removeNeighbor(key)

        del self.vertList[key] 

    def getVertex(self,n):
        if n in self.vertList:
            return self.vertList[n]
        else:
            return None

    def __contains__(self,n):
        return n in self.vertList

    def getAllVertex(self):
        return [x.key for x in self.vertList] 

    def addLink(self, f, t):
        if f not in self.vertList:
            nv = self.addVertex(f)
        if t not in self.vertList:
            nv = self.addVertex(t)
        self.vertList[f].addNeighbor(self.vertList[t])
        self.vertList[t].addNeighbor(self.vertList[f])
        self.linkList.add((f,t))

    def removeLink(self, a, b):
        if (a,b) in self.linkList:
            self.linkList.remove((a,b))

    def countLinks(self):
        return sum([len(v.getConnections()) for v in self.vertList.values()])/2

    def getVertices(self):
        return self.vertList.keys()

    def __len__(self):
        return len(self.vertList)

    def __iter__(self):
        return iter(self.vertList.values())

# ============================================================================== #

def getNbrOfNbr(A, B):
    nbr_a = set(A.getConnections())
    nbr_b = set(B.getConnections())

    for v in nbr_a:
        nbr_a = nbr_a | set(v.getConnections())
    nbr_a = nbr_a - set([A])
    
    for v in nbr_b:
        nbr_b = nbr_b | set(v.getConnections())
    nbr_b = nbr_b - set([B])

    return (nbr_a, nbr_b)


def commonNeighbors(graph, A, B):
    nbr_a, nbr_b = getNbrOfNbr(A, B)
    return len(nbr_a & nbr_b)


def jaccard(graph, A, B):
    nbr_a, nbr_b = getNbrOfNbr(A, B)

    inter = nbr_a & nbr_b
    union = nbr_a | nbr_b

    if len(union) <= 0:
        return 0

    return len(inter) / float(len(union))

def adamic_adar(graph, A, B):
    nbr_a, nbr_b = getNbrOfNbr(A, B)
    inter = nbr_a & nbr_b

    result = 0
    for v in inter:
        ncon = len(v.getConnections())
        if ncon > 0:
            if math.log(ncon) > 0:
                result += 1.0/math.log(ncon)
    return result


def triangles(graph):
    for vertex in graph:
        vs = vertex.getConnections()
        ntriangles = 0
        for w in vs:
            try:
                ws = w.getConnections()
                ntriangles += len(set(vs) & set(ws))
            except KeyError: 
                print w
        yield (vertex.getId(), len(vs), ntriangles)

def localCoefficient(graph):
    td_iter = triangles(graph)
    clusterc = {}

    for v,d,t in td_iter:
        if t == 0:
            clusterc[v] = 0.0
        else:
            clusterc[v] = t/float(d*(d-1))

    return clusterc

def globalCoefficient(graph):
    nTriangles=0 # 6 times number of triangles
    contri=0  # 2 times number of connected triples

    for v,d,t in triangles(graph):
        contri += d*(d-1)
        nTriangles += t
    if nTriangles==0: # we had no triangles or possible triangles
        return 0.0
    else:
        return nTriangles/float(contri)

def avgDegree(graph):
    degrees = [v.degree for v in graph]
    return sum(degrees)/float(len(degrees))

def removeRandomVertex(graph, n, minDegree = None, maxDegree = None):  
    minList = maxList = []

    if minDegree is not None:
        minList = [v for v in graph if v.degree < minDegree]

    if maxDegree is not None:
        maxList = [v for v in graph if v.degree > maxDegree]

    vertList = set([v for v in graph]) - set(minList) - set(maxList)
    
    if n < len(vertList):
        v = random.sample(vertList, n)        
    else:
        v = vertList

    for i in v:
        graph.removeVertex(i.getId())

def removeRandomLinks(graph, vertex=None, verbose=True):
    if vertex is None:
        vertex = random.choice(graph.getVertices())

    vertex = graph.getVertex(vertex)

    if len(vertex.getConnections()) <= 0:
        return

    nbr = random.sample(vertex.getConnections(), 1)
    vertex.removeNeighbor(nbr[0], verbose=verbose)
    graph.removeLink(vertex, nbr[0])
    return (vertex, nbr[0])


def nbrs_key(item):
    return item[1]


def calculatePossibleNbrs(graph, A, maxResults = None, alg='jaccard', minRes=None):
    algorithms = {
        'jaccard': jaccard,
        'common': commonNeighbors,
        'adamic_adar': adamic_adar,
    }

    nbrsList = []
    
    notNbr = set(graph.vertList.values()) - A.getConnections()

    for vx in notNbr:
        if vx.getId() != A.getId():

            if vx.getId() in [i.getId() for i in list(A.getConnections())]:
                'V ja eh amigo de A'

            if alg in algorithms:
                res = algorithms[alg](graph, A, vx)
            else:
                raise ValueError("Algoritmo invalido!")
            
            nbrsList.append((vx, res))
            #print "{} e {} | {} = {}".format(A.getId(), v, alg, res)

    if minRes is not None:
        nbrsList = [i for i in nbrsList if i >= minRes]

    TopNbrs = sorted(nbrsList, key=nbrs_key, reverse=True)
    return TopNbrs[:int(len(TopNbrs)*0.05)]
    # return TopNbrs[:10]


def calculateRank(graph, a, minList=None):
    if minList is None:
        minList = {'jac': 0.75, 'cn': 200, 'adad': 75.0}
    elif 'jac' not in minList or 'cn' not in minList or 'adad' not in minList:
        raise ValueError('Lista de limiares invalida')

    jac = calculatePossibleNbrs(graph, a, minRes=minList['jac'])
    cn = calculatePossibleNbrs(graph, a, alg='common', minRes=minList['cn'])
    adad = calculatePossibleNbrs(graph, a, alg='adamic_adar', minRes=minList['adad'])
    # print "JAC = {} \n\n CN = {}\n".format(jac, cn)

    if jac > 0 and cn > 0 and adad > 0:
        return {'id': a.getId(), 'vertex': a, 'jac': jac, 'cn': cn, 'adad': adad}
    return None

def calculateSampleNbrs(graph, n, parallel=False):

    aList = [graph.getVertex(x) for x in random.sample(graph.vertList, n)]

    start_time = time()
    last_time = time()
    
    if parallel is True:
        p = Pool(processes = 4)
        resList = [p.apply_async(calculateRank, args=(graph, x)) for x in aList]
        output = [o.get() for o in resList]
    else:
        output = [calculateRank(graph, x) for x in aList]

    output = [o for o in output if o != None]

    end_time = time()
    elapsed_total = end_time - start_time
    human_time = str(timedelta(seconds=int(elapsed_total)))
    print human_time
    # print output
    return output

# ============================================================================== #

if __name__ == '__main__':

    PARALLEL = True # Rodar algoritmos de classificacao de melhor vizinho em paralelo
    NSAMPLES = 100 # Numero de vertexs aleatorias a classificar melhores conexoes
    MAXREMOVE = 400 # Numero maximo de vertexs a remover
    MINDEGREE = 125 # Minimo de conexoes para nao excluir o vertex
    MAXDEGREE = 50 # Maximo de conexoes para nao excluir o vertex
    REMOVE_VERBOSE = False # Mostrar ou nao quando um vertex eh removido
    algs = ['jac', 'cn', 'adad']
    labels = {'jac': 'Jaccard', 'cn': 'Common Neighbors', 'adad': 'Adamic Adar'}

    graphs = []
    for i in range(4):
        graphs.append(Graph())

    with open('facebooklinks.txt') as f:
        for line in f:
            a, b = line.rstrip('\n').split(' ')
            for g in graphs:
                g.addLink(a, b)

    removeRandomVertex(graphs[2], MAXREMOVE, minDegree=MINDEGREE)
    removeRandomVertex(graphs[3], MAXREMOVE, maxDegree=MAXDEGREE)

    removed = [[],[],[]]
    print 'Removendo links aleatorios'
    for i in range(1, 4):
        for j in range(int(graphs[i].countLinks()*0.2)):
            r = removeRandomLinks(graphs[i], verbose=REMOVE_VERBOSE)
            if r is not None:
                removed[i-1].append(r)


    print 'Iniciando o calculo de ranks'
    graph_scores = []
    
    graph_desc = [
        'Remocao aleatoria de links',
        'Remocao dos vertices com mais conexoes + Remocao aleatoria de links',
        'Remocao dos vertices com menos conexoes  + Remocao aleatoria de links'
    ]

    # Itera entre os 3 grafos que tiveram pre-processamento
    for i in range(1,4):
        print 'Iniciando o calculo do grafo #{} - {}'.format(i, graph_desc[i-1])
        # Calcula os melhores vizinhos para conectar
        out = calculateSampleNbrs(graphs[i], NSAMPLES, parallel=PARALLEL)
        r = set(removed[i-1])
        scores = []
        for o in out:
            score = {}
            # Escolha apenas os links (dentre os removidos que podem ser comparados) que possuem algum id em comum 
            minr = [(i[0].getId(), i[1].getId()) for i in r if i[0].getId() == o['vertex'].getId() or i[1].getId() == o['vertex'].getId()]
            for alg in algs:
                # Cria um vetor com o id do vertice de tamanho do vetor de vertices previstos para junta-los
                x = [o['vertex'].getId() for _ in o[alg]]
                y = [y[0].getId() for y in o[alg]]
                # Junta das duas maneira para facilitar a interseccao
                connections = zip(x, y) + zip(y, x)
                inter = set(connections) & set(minr)
                # Calcula a porcentagem de acertos em relacao a quantos foram previstos
                rank = len(inter)/float(len(set(o[alg])))
                # Salva tudo em uma tupla
                score[alg] = (rank, inter, set(o[alg]))
            # Salva as tuplas de um mesmo vertice em scores
            scores.append(score)
        # Salva os scores de um mesmo grafo em graph_scores
        graph_scores.append(scores)

    i = 1
    mean_somas = {'jac' : [], 'cn' : [], 'adad': [], 'mean': []}
    for scores in graph_scores:
        print 'Resultados do grafo #{} - {}\n'.format(i, graph_desc[i-1])
        somas = []
        algsomas = {'jac' : [], 'cn' : [], 'adad': []}
        for score in scores:
            soma = 0
            for alg in algs:
                print '{}: {} | Acertos = {} | Total previsto = {}'.format(labels[alg], score[alg][0], len(score[alg][1]), len(score[alg][2]))
                soma += score[alg][0]
                algsomas[alg].append(score[alg][0])
            print 'Mean Scores: {}\n'.format(soma/3)
            somas.append(soma)
        for alg in algs:
            amean = sum(algsomas[alg])/float(len(algsomas[alg]))
            mean_somas[alg].append(amean)
            print '{} Mean = {}'.format(labels[alg], amean)
        tmean = sum(somas)/float(len(somas)*3)
        mean_somas['mean'].append(tmean)
        print 'Total Mean = {}\n\n'.format(tmean)
        i += 1
    print '\n================================================'
    print 'Medias finais de todos os grafos:'
    print '================================================\n'
    for alg in algs:
        print '{} Mean = {}'.format(labels[alg], sum(mean_somas[alg])/float(len(mean_somas[alg])))
    print 'Mean = {}'.format(sum(mean_somas['mean'])/float(len(mean_somas['mean'])))
