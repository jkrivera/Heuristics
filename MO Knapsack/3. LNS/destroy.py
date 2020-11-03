import numpy as np
import random
from validate import validate


def Drand(N,M,P,c,a,b,Fs):

    it=0
    while it < 0.2*Fs.Xs[0]:
        it=it+1
        
        sel = random.randint(1,Fs.Xs[0])
        
        Fs.Z[P] = 0
        for m in range(M):
            Fs.R[m] = Fs.R[m] - a[m][int(Fs.Xs[sel])]
            if Fs.R[m] > b[m]:
                Fs.Z[P] = Fs.Z[P] + 1
        for p in range(P):
            Fs.Z[p] = Fs.Z[p] - c[p][int(Fs.Xs[sel])]
        Fs.X[int(Fs.Xs[sel])] = 0
        Fs.Xn[0] = Fs.Xn[0] + 1
        Fs.Xn[int(Fs.Xn[0])] = Fs.Xs[sel]
        Fs.Xs[0] = Fs.Xs[0] - 1
        for h in range(sel,int(Fs.Xs[0])+2):
            Fs.Xs[h] = Fs.Xs[h+1]
        
        H=[]
        H.append(Fs)
        validate(N,M,P,c,a,b,H,1)

    return Fs