import networkx as nx
import matplotlib.pyplot as plt
import trabalho3 as t3

G = []
nxG = nx.Graph()
graphs = []
for i in range(4):
    graphs.append(t3.Graph())
    G.append(nx.Graph())

with open('facebooklinks.txt') as f:
    for line in f:
        a, b = line.rstrip('\n').split(' ')
        nxG.add_edge(a, b)
        for g in graphs:
            g.addLink(a, b)


t3.removeRandomVertex(graphs[2], 400, minDegree=125)
t3.removeRandomVertex(graphs[3], 400, maxDegree=50)

removed = [[],[],[]]
for i in range(1, 4):
    for j in range(int(graphs[i].countLinks()*0.2)):
        removed[i-1].append(t3.removeRandomLinks(graphs[i]))


for i in range(1, 4):
	G[i].add_edges_from(graphs[i].linkList)
	pos=nx.spring_layout(G[i], k=0.5)
	colors=range(G[i].number_of_edges())
	nx.draw(G[i],pos,node_color='#A0CBE2',edge_color=colors,width=1,edge_cmap=plt.cm.Blues,with_labels=False,node_size=20)
	#plt.savefig("edge_colormap_"+str(i)+".png") # save as png
	plt.show() # display


# degree_sequence=sorted(nx.degree(G).values(),reverse=True) # degree sequence
# #print "Degree sequence", degree_sequence
# dmax=max(degree_sequence)

# plt.loglog(degree_sequence,'b-',marker='o')
# plt.title("Degree rank plot")
# plt.ylabel("degree")
# plt.xlabel("rank")

# # draw graph in inset
# plt.axes([0.45,0.45,0.45,0.45])
# Gcc=sorted(nx.connected_component_subgraphs(G), key = len, reverse=True)[0]
# pos=nx.spring_layout(Gcc)
# plt.axis('off')
# nx.draw_networkx_nodes(Gcc,pos,node_size=20)
# nx.draw_networkx_edges(Gcc,pos,alpha=0.4)

# plt.savefig("degree_histogram.png")
# plt.show()
