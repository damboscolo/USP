import networkx as nx
import matplotlib.pyplot as plt

G = nx.Graph()
with open('facebooklinks.txt') as f:
    for line in f:
        a, b = line.rstrip('\n').split(' ')
        G.add_edge(a, b)

try:
    import matplotlib.pyplot as plt
    plt.figure(figsize=(8,8))
    # with nodes colored by degree sized by population
    node_color=[float(H.degree(v)) for v in H]
    nx.draw(H,G.position,
         node_size=[G.population[v] for v in H],
         node_color=node_color,
         with_labels=False)

    # scale the axes equally
    plt.xlim(-5000,500)
    plt.ylim(-2000,3500)

    plt.savefig("knuth_miles.png")
except:
    pass