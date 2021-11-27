import numpy as np
import time
import random


from solution_class import Solution


def N1(N,M,P,c,a,b,F,s,ns,k):
    for i in range(1,int(F[s-1].Xn[0])+1):
        dom = 1
        Ra = np.zeros((M))
        Za = np.zeros((P+1))
        for j in range(M):
            Ra[j] = F[s-1].R[j] + a[j][int(F[s-1].Xn[i])]
            if Ra[j] > b[j]:
                Za[P] = Za[P] + 1
                if Za[P] > F[s-1].Z[P]:
                    break
        if Za[P] <= F[s-1].Z[P]:
            if Za[P] < F[s-1].Z[P]:
                dom = 0
            for p in range(P):
                Za[p] = F[s-1].Z[p] + c[p][int(F[s-1].Xn[i])]
                if Za[p] > F[s-1].Z[p]:
                    dom = 0
        
        if dom==0:
            X = F[s-1].X.copy()
            X[int(F[s-1].Xn[i])] = 1
            Xn = F[s-1].Xn.copy()
            Xs = F[s-1].Xs.copy()
            Xs[0]=Xs[0]+1
            Xs[int(Xs[0])]=F[s-1].Xn[i]
            Xn[0]=Xn[0]-1
            for h in range(i,int(Xn[0]+2)):
                Xn[h]=Xn[h+1]
            F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
            ns=ns+1
    
    return F, k, ns


def N2(N,M,P,c,a,b,F,s,ns,k):
    for i in range(1,int(F[s-1].Xs[0])+1):
        dom = 1
        Ra = np.zeros((M))
        Za = np.zeros((P+1))
        for j in range(M):
            Ra[j] = F[s-1].R[j] - a[j][int(F[s-1].Xs[i])]
            if Ra[j] > b[j]:
                Za[P] = Za[P] + 1
                if Za[P] > F[s-1].Z[P]:
                    break
        if Za[P] <= F[s-1].Z[P]:
            if Za[P] < F[s-1].Z[P]:
                dom = 0
            for p in range(P):
                Za[p] = F[s-1].Z[p] - c[p][int(F[s-1].Xs[i])]
                if Za[p] > F[s-1].Z[p]:
                    dom = 0
        
        if dom == 0:
            X = F[s-1].X.copy()
            X[int(F[s-1].Xs[i])] = 0
            Xn = F[s-1].Xn.copy()
            Xn[0]=Xn[0]+1
            Xn[int(Xn[0])]=F[s-1].Xs[i]
            Xs = F[s-1].Xs.copy()
            Xs[0]=Xs[0]-1
            for j in range(i,int(Xs[0]+2)):
                Xs[j]=Xs[j+1]
            F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
            ns=ns+1
    
    return F, k, ns


def N3(N,M,P,c,a,b,F,s,ns,k):
    
    for i in range(1,int(F[s-1].Xs[0]+1)):
        for j in range(1,int(F[s-1].Xn[0]+1)):
            dom = 1
            Ra = np.zeros((M))
            Za = np.zeros((P+1))
            for m in range(M):
                Ra[m] = F[s-1].R[m] - a[m][int(F[s-1].Xs[i])] + a[m][int(F[s-1].Xn[j])]
                if Ra[m] > b[m]:
                    Za[P] = Za[P] + 1
                    if Za[P] > F[s-1].Z[P]:
                        break
            if Za[P] <= F[s-1].Z[P]:
                if Za[P] < F[s-1].Z[P]:
                    dom = 0
                for p in range(P):
                    Za[p] = F[s-1].Z[p] - c[p][int(F[s-1].Xs[i])] + c[p][int(F[s-1].Xn[j])]
                    if Za[p] > F[s-1].Z[p]:
                        dom = 0
            
            if dom == 0:
                X = F[s-1].X.copy()
                X[int(F[s-1].Xs[i])] = 0
                X[int(F[s-1].Xn[j])] = 1
                Xn = F[s-1].Xn.copy()
                Xs = F[s-1].Xs.copy()
                Xn[j]=F[s-1].Xs[i]
                Xs[i]=F[s-1].Xn[j]
                F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
                ns=ns+1

    return F, k, ns


def N4(N,M,P,c,a,b,F,s,ns,k,cputime):
    for i1 in range(1,int(F[s-1].Xs[0]+1)):
        if random.random() < 0.84:
            for i2 in range(i1+1,int(F[s-1].Xs[0]+1)):
                if random.random() < 0.84:
                    for j1 in range(1,int(F[s-1].Xn[0]+1)):
                        if random.random() < 0.84:
                            for j2 in range(j1+1,int(F[s-1].Xn[0]+1)):
                                if random.random() < 0.84:
                                    dom = 1
                                    Ra = np.zeros((M))
                                    Za = np.zeros((P+1))
                                    for m in range(M):
                                        Ra[m] = F[s-1].R[m] - a[m][int(F[s-1].Xs[i1])] - a[m][int(F[s-1].Xs[i2])] + a[m][int(F[s-1].Xn[j1])] + a[m][int(F[s-1].Xn[j2])]
                                        if Ra[m] > b[m]:
                                            Za[P] = Za[P] + 1
                                            if Za[P] > F[s-1].Z[P]:
                                                break
                                    if Za[P] <= F[s-1].Z[P]:
                                        if Za[P] < F[s-1].Z[P]:
                                            dom = 0
                                        for p in range(P):
                                            Za[p] = F[s-1].Z[p] - c[p][int(F[s-1].Xs[i1])] - c[p][int(F[s-1].Xs[i2])] + c[p][int(F[s-1].Xn[j1])] + c[p][int(F[s-1].Xn[j2])]
                                            if Za[p] > F[s-1].Z[p]:
                                                dom = 0
                                    
                                    if dom == 0:
                                        X = F[s-1].X.copy()
                                        X[int(F[s-1].Xs[i1])] = 0
                                        X[int(F[s-1].Xs[i2])] = 0
                                        X[int(F[s-1].Xn[j1])] = 1
                                        X[int(F[s-1].Xn[j2])] = 1
                                        Xn = F[s-1].Xn.copy()
                                        Xs = F[s-1].Xs.copy()
                                        Xn[j1]=F[s-1].Xs[i1]
                                        Xs[i1]=F[s-1].Xn[j1]
                                        Xn[j2]=F[s-1].Xs[i2]
                                        Xs[i2]=F[s-1].Xn[j2]
                                        F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
                                        ns=ns+1
                                    
                                if (time.time()-cputime) > 5*60:
                                    break
                        if (time.time()-cputime) > 5*60:
                            break
                if (time.time()-cputime) > 5*60:
                    break
        if (time.time()-cputime) > 5*60:
            break

    return F, k, ns


def N5(N,M,P,c,a,b,F,s,ns,k,cputime):
    for i1 in range(1,int(F[s-1].Xs[0]+1)):
        for j1 in range(1,int(F[s-1].Xn[0]+1)):
            for j2 in range(j1+1,int(F[s-1].Xn[0]+1)):
#                    if random.random() < 0.5:
                    dom = 1
                    Ra = np.zeros((M))
                    Za = np.zeros((P+1))
                    for m in range(M):
                        Ra[m] = F[s-1].R[m] - a[m][int(F[s-1].Xs[i1])] + a[m][int(F[s-1].Xn[j1])] + a[m][int(F[s-1].Xn[j2])]
                        if Ra[m] > b[m]:
                            Za[P] = Za[P] + 1
                            if Za[P] > F[s-1].Z[P]:
                                break
                    if Za[P] <= F[s-1].Z[P]:
                        if Za[P] < F[s-1].Z[P]:
                            dom = 0
                        for p in range(P):
                            Za[p] = F[s-1].Z[p] - c[p][int(F[s-1].Xs[i1])] + c[p][int(F[s-1].Xn[j1])] + c[p][int(F[s-1].Xn[j2])]
                            if Za[p] > F[s-1].Z[p]:
                                dom = 0
                    
                    if dom == 0:
                        X = F[s-1].X.copy()
                        X[int(F[s-1].Xs[i1])] = 0
                        X[int(F[s-1].Xn[j1])] = 1
                        X[int(F[s-1].Xn[j2])] = 1
                        Xn = F[s-1].Xn.copy()
                        Xs = F[s-1].Xs.copy()
                        Xn[j1]=F[s-1].Xs[i1]
                        Xs[i1]=F[s-1].Xn[j1]
                        Xs[0]=Xs[0]+1
                        Xs[int(Xs[0])]=F[s-1].Xn[j2]
                        Xn[0]=Xn[0]-1
                        for h in range(j2,int(Xn[0]+2)):
                            Xn[h]=Xn[h+1]
                        F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
                        ns=ns+1
                    
#                        if (time.time()-cputime) > 5*60:
#                            break
#                if (time.time()-cputime) > 5*60:
#                    break
#        if (time.time()-cputime) > 5*60:
#            break

    return F, k, ns


def N6(N,M,P,c,a,b,F,s,ns,k,cputime):
    for i1 in range(1,int(F[s-1].Xs[0]+1)):
        for i2 in range(i1+1,int(F[s-1].Xs[0]+1)):
            for j1 in range(1,int(F[s-1].Xn[0]+1)):
#                    if random.random() < 0.5:
                    dom = 1
                    Ra = np.zeros((M))
                    Za = np.zeros((P+1))
                    for m in range(M):
                        Ra[m] = F[s-1].R[m] - a[m][int(F[s-1].Xs[i1])] - a[m][int(F[s-1].Xs[i2])] + a[m][int(F[s-1].Xn[j1])]
                        if Ra[m] > b[m]:
                            Za[P] = Za[P] + 1
                            if Za[P] > F[s-1].Z[P]:
                                break
                    if Za[P] <= F[s-1].Z[P]:
                        if Za[P] < F[s-1].Z[P]:
                            dom = 0
                        for p in range(P):
                            Za[p] = F[s-1].Z[p] - c[p][int(F[s-1].Xs[i1])] - c[p][int(F[s-1].Xs[i2])] + c[p][int(F[s-1].Xn[j1])]
                            if Za[p] > F[s-1].Z[p]:
                                dom = 0
                    
                    if dom == 0:
                        X = F[s-1].X.copy()
                        X[int(F[s-1].Xs[i1])] = 0
                        X[int(F[s-1].Xs[i2])] = 0
                        X[int(F[s-1].Xn[j1])] = 1
                        Xn = F[s-1].Xn.copy()
                        Xs = F[s-1].Xs.copy()
                        Xn[j1]=F[s-1].Xs[i1]
                        Xs[i1]=F[s-1].Xn[j1]
                        Xn[0]=Xn[0]+1
                        Xn[int(Xn[0])]=F[s-1].Xs[i2]
                        Xs[0]=Xs[0]-1
                        for j in range(i2,int(Xs[0]+2)):
                            Xs[j]=Xs[j+1]
                        F.append(Solution(X,Xs,Xn,Za,Ra,np.zeros((6))))
                        ns=ns+1
                    
#                        if (time.time()-cputime) > 5*60:
#                            break
#                if (time.time()-cputime) > 5*60:
#                    break
#            if (time.time()-cputime) > 5*60:
#                break
#        if (time.time()-cputime) > 5*60:
#            break

    return F, k, ns
