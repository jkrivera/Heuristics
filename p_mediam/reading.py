import numpy as np
import math

def reading(ins):

    file = 'pmedcap' + str(ins) + '.txt'
    with open(file) as f:
        firstline = f.readline().rstrip()
    firstline=np.array(firstline.split('\t'))
    dat = np.loadtxt(file, delimiter = '\t', skiprows = 1)

    p = int(firstline[1])
    n = int(firstline[0])
    Q = int(dat[0][2])
    
    q=[]
    for i in range(n):
        q.append(dat[i][3])
    
    c=[]
    for i in range(n):
        c.append([])
        for j in range(n):
            d = int(math.sqrt((dat[i][0] - dat[j][0])**2 + ((dat[i][1] - dat[j][1])**2)))
            c[i].append(d)

    return n, p, Q, q, c