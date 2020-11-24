import numpy as np
import random

from validate import validate
from solution_class import Solution


def Drand(N,M,P,c,a,b,F,s):

    X = F[s].X.copy()
    Xs = F[s].Xs.copy()
    Xn = F[s].Xn.copy()
    Z = F[s].Z.copy()
    R = F[s].R.copy()
    
    it=0
    while it < 0.3*Xs[0]:
        it=it+1
        
        sel = random.randint(1,Xs[0])
        
        Z[P] = 0
        for m in range(M):
            R[m] = R[m] - a[m][int(Xs[sel])]
            if R[m] > b[m]:
                Z[P] = Z[P] + 1
        for p in range(P):
            Z[p] = Z[p] - c[p][int(Xs[sel])]
        X[int(Xs[sel])] = 0
        Xn[0] = Xn[0] + 1
        Xn[int(Xn[0])] = Xs[sel]
        Xs[0] = Xs[0] - 1
        for h in range(sel,int(Xs[0])+2):
            Xs[h] = Xs[h+1]
        
        Fs=[]
        Fs.append(Solution(X,Xs,Xn,Z,R))

    return Fs


def Drand2(N,M,P,c,a,b,F,s):

    X = F[s].X.copy()
    Xs = F[s].Xs.copy()
    Xn = F[s].Xn.copy()
    Z = F[s].Z.copy()
    R = F[s].R.copy()
    
    it=0
    while it < 0.2*Xn[0]:
        it=it+1
        
        sel = random.randint(1,Xn[0])
        
        Z[P] = 0
        for m in range(M):
            R[m] = R[m] - a[m][int(Xn[sel])]
            if R[m] > b[m]:
                Z[P] = Z[P] + 1
        for p in range(P):
            Z[p] = Z[p] - c[p][int(Xn[sel])]
        X[int(Xn[sel])] = 0
        Xs[0] = Xs[0] + 1
        Xs[int(Xs[0])] = Xn[sel]
        Xn[0] = Xn[0] - 1
        for h in range(sel,int(Xn[0])+2):
            Xn[h] = Xn[h+1]
        
        Fs=[]
        Fs.append(Solution(X,Xs,Xn,Z,R))

    return Fs