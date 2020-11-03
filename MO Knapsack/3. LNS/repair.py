import numpy as np
import random


from solution_class import Solution


def Rgreedy(N,M,P,c,a,b,UB,LB,Fo,F,ns,cputime):

    Fp = Fo.copy()
    w = [0.9, 0.05, 0.05]
    
    check = np.zeros((N))
    for i in range(int(Fp[0].Xs[0])):
        check[int(Fp[0].Xs[i])] = 1
    
    ap = np.zeros((M, N))
    
    if Fp[0].Z[P] > 0:
        fact = 0
    else:
        fact = 1


# Find a feasible solution
    
    while sum(check) < N and fact == 0:
    
        Rp = np.zeros((N))
        Rn = np.ones((N))
        sel = -1
        for j in range(N):
            if check[j] == 0:
                for i in range(M):
                    ap[i][j] = a[i][j] / (b[i]-Fp[0].R[i]+0.001)
                    if b[i] >= 0 and Fp[0].R[i]+a[i][j] > b[i]:
                        check[j] = 1
                        break
                    if b[i] >= 0 and ap[i][j] > Rp[j]:
                        Rp[j] = ap[i][j]
                    if b[i] < 0 and ap[i][j] < Rn[j]:
                        Rn[j] = ap[i][j]
    
                if check[j] == 0:
                    if sel == -1:
                        sel = j
                    else:
                        if Rn[j] > Rn[sel]:
                            sel = j
                        else:
                            if Rn[j] == Rn[sel] and Rp[j] < Rp[sel]:
                                sel = j

        if sel >= 0:                                
            Fp[0].X[sel] = 1
            check[sel] = 1
            fact = 1
            for i in range(M):
                Fp[0].R[i] = Fp[0].R[i] + a[i][sel]
                if fact == 1 and Fp[0].R[i] > b[i]:
                    fact = 0
            for p in range(P):
                Fp[0].Z[p] = Fp[0].Z[p] + c[p][sel]
    

# Find a better solution
    
    while sum(check) < N and fact == 1:
    
        Rp = np.ones((N)) * np.Infinity
        sel = -1
        for j in range(N):
            if check[j] == 0:
                Rp[j] = 0
                for p in range(P):
                    ap[p][j] = (Fp[0].Z[p]-LB[p])/(UB[p]-LB[p])
                    Rp[j] = Rp[j] + w[p]*ap[p][j]
                for i in range(M):
                    if Fp[0].R[i]+a[i][j] > b[i]:
                        check[j] = 1
                        break
    
                if check[j] == 0:
                    if sel == -1:
                        sel = j
                    else:
                        if Rp[j] > Rp[sel]:
                            sel = j

        if sel >= 0:                                
            X[sel] = 1
            check[sel] = 1
            fact = 1
            for i in range(M):
                R[i] = R[i] + a[i][sel]
                if fact == 1 and R[i] > b[i]:
                    fact = 0
            for p in range(P):
                Z[p] = Z[p] + c[p][sel]
    
    Z[p+1] = 0
    for i in range(M):
        if R[i]>b[i]:
            Z[p+1] = Z[p+1] +1
            
    Xs = np.zeros((N+1))
    Xn = np.zeros((N+1))
    for i in range(N):
        if X[i]==1:
            Xs[0]=Xs[0]+1
            Xs[int(Xs[0])] = i
        else:
            Xn[0]=Xn[0]+1
            Xn[int(Xn[0])] = i

    F = []
    F.append(Solution(X,Xs,Xn,Z,R,np.zeros((6))))
    ns = 1

    return F, ns


def Rexact(N,M,P,c,a,b,Fp,F,ns,cputime):

    it=0
    while it < 0.1*Fs.Xs[0]:
        it=it+1
        
        sel = random.randint(1,Fs.Xs[0])

    return F, ns