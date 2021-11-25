import numpy as np


def validate(N,M,P,c,a,b,F):
    
    Rv = np.zeros((M))
    Zv = np.zeros((P+1))
    
    for i in range(1,int(F.Xs[0]+1)):
        if F.X[int(F.Xs[i])] != 1:
            print("Error")
    
    for i in range(1,int(F.Xn[0]+1)):
        if F.X[int(F.Xn[i])] != 0:
            print("Error")

    for m in range(M):
        for i in range(N):
            Rv[m] = Rv[m] + a[m][i]*F.X[i]
        if Rv[m] != F.R[m]:
            print("Error")
        if Rv[m] > b[m]:
            Zv[P] = Zv[P] + 1
            
    for p in range(P):
        for i in range(N):
            Zv[p] = Zv[p] + c[p][i]*F.X[i]
        if Zv[p] != F.Z[p]:
            print("Error")
    
    if Zv[P] != F.Z[P]:
        print("Error")