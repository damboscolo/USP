import trabalho3 as t3


graphs = []
for i in range(4):
    graphs.append(t3.Graph())

with open('facebooklinks.txt') as f:
    for line in f:
        a, b = line.rstrip('\n').split(' ')
        for g in graphs:
            g.addLink(a, b)


t3.removeRandomVertex(graphs[2], 400, minDegree=125)
t3.removeRandomVertex(graphs[3], 400, maxDegree=50)

removed = [[],[],[]]
for i in range(1, 4):
    for j in range(int(graphs[i].countLinks()*0.2)):
        removed[i-1].append(t3.removeRandomLinks(graphs[i]))

for i in range(4):
	g = graphs[i]
	print 'Coeficientes do grafo '+str(i+1)
	local = t3.localCoefficient(g).values()
	print sum(local)/float(len(local))
	print t3.globalCoefficient(g)
	print t3.avgDegree(g)
	print '\n'