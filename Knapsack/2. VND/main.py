# -*- coding: utf-8 -*-

from xlrd import open_workbook
import numpy as np
import time
import random


from reading import reading
from construction import construction
from vnd import vnd

f = np.zeros((20))

for ins in range(1,21):
    N, M, P, c, a, b = reading(ins)
    
    cputime = time.time()
    
    X, Z, R = construction(N,M,P,c,a,b)
    
    Xs = np.zeros((N+1))
    Xn = np.zeros((N+1))
    for i in range(N):
        if X[i]==1:
            Xs[0]=Xs[0]+1
            Xs[int(Xs[0])] = i
        else:
            Xn[0]=Xn[0]+1
            Xn[int(Xn[0])] = i
            
    X, Xs, Xn, Z, R = vnd(N,M,P,c,a,b,X,Xs,Xn,Z,R)

    print("I" + str(ins))
    print(Z[P])
    print("%1.2f \t" % (time.time()-cputime))
    print("")
#    f[ins-1] = fact
print(str(f))