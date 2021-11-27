import numpy as np


def validate(N,M,P,c,a,b,F,nsnew):
    
    for s in range(nsnew):
        Rv = np.zeros((M))
        Zv = np.zeros((P+1))
        
        for i in range(1,int(F[s].Xs[0]+1)):
            if F[s].X[int(F[s].Xs[i])] != 1:
                print("Error")
        
        for i in range(1,int(F[s].Xn[0]+1)):
            if F[s].X[int(F[s].Xn[i])] != 0:
                print("Error")

        for m in range(M):
            for i in range(N):
                Rv[m] = Rv[m] + a[m][i]*F[s].X[i]
            if Rv[m] != F[s].R[m]:
                print("Error")
            if Rv[m] > b[m]:
                Zv[P] = Zv[P] + 1
                
        for p in range(P):
            for i in range(N):
                Zv[p] = Zv[p] + c[p][i]*F[s].X[i]
            if Zv[p] != F[s].Z[p]:
                print("Error")
        
        if Zv[P] != F[s].Z[P]:
            print("Error")