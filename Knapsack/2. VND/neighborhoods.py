import numpy as np
import time
import random


from solution_class import Solution


def N1(N,M,P,c,a,b,F,k):
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    ib = -1
    for i in range(1,int(F.Xn[0])+1):
        Ra = np.zeros((M))
        Za = np.zeros((P+1))
        Za[0] = F.Z[0] + c[0][int(F.Xn[i])]
        if Za[0] < Zb[0] and Zb[P] == 0:
            continue
        for j in range(M):
            Ra[j] = F.R[j] + a[j][int(F.Xn[i])]
            if Ra[j] > b[j]:
                Za[P] = Za[P] + 1
                if Za[P] > F.Z[P]:
                    break
        if Za[P] < Zb[P]:
            Rb = Ra.copy()
            Zb = Za.copy()
            ib = i
        else:
            if Za[0] > Zb[0] and Za[P] == Zb[P]:
                Rb = Ra.copy()
                Zb = Za.copy()
                ib = i
            
    if ib != -1:
        k = 1
        F.X[int(F.Xn[ib])] = 1
        F.Xs[0]=F.Xs[0]+1
        F.Xs[int(F.Xs[0])]=F.Xn[ib]
        F.Xn[0]=F.Xn[0]-1
        for h in range(ib,int(F.Xn[0]+2)):
            F.Xn[h]=F.Xn[h+1]
        F.R = Rb.copy()
        F.Z = Zb.copy()
    
    return F, k


def N2(N,M,P,c,a,b,F,k):
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    ib = -1
    for i in range(1,int(F.Xs[0])+1):
        Ra = np.zeros((M))
        Za = np.zeros((P+1))
        Za[0] = F.Z[0] - c[0][int(F.Xs[i])]
        if Za[0] < Zb[0] and Zb[P] == 0:
            continue
        for j in range(M):
            Ra[j] = F.R[j] - a[j][int(F.Xs[i])]
            if Ra[j] > b[j]:
                Za[P] = Za[P] + 1
                if Za[P] > F.Z[P]:
                    break
        if Za[P] < Zb[P]:
            Rb = Ra.copy()
            Zb = Za.copy()
            ib = i
        else:
            if Za[0] > Zb[0] and Za[P] == Zb[P]:
                Rb = Ra.copy()
                Zb = Za.copy()
                ib = i
        
    if ib != -1:
        k=1
        F.X[int(F.Xs[ib])] = 0
        F.Xn[0]=F.Xn[0]+1
        F.Xn[int(F.Xn[0])]=F.Xs[ib]
        F.Xs[0]=F.Xs[0]-1
        for j in range(ib,int(F.Xs[0]+2)):
            F.Xs[j]=F.Xs[j+1]
        F.R = Rb.copy()
        F.Z = Zb.copy()
    
    return F, k


def N3(N,M,P,c,a,b,F,k):
    
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    ib = -1
    jb = -1
    for i in range(1,int(F.Xs[0]+1)):
        for j in range(1,int(F.Xn[0]+1)):
            Ra = np.zeros((M))
            Za = np.zeros((P+1))
            Za[0] = F.Z[0] - c[0][int(F.Xs[i])] + c[0][int(F.Xn[j])]
            if Za[0] < Zb[0] and Zb[P] == 0:
                continue
            for m in range(M):
                Ra[m] = F.R[m] - a[m][int(F.Xs[i])] + a[m][int(F.Xn[j])]
                if Ra[m] > b[m]:
                    Za[P] = Za[P] + 1
                    if Za[P] > F.Z[P]:
                        break
            if Za[P] < Zb[P]:
                Rb = Ra.copy()
                Zb = Za.copy()
                ib = i
                jb = j
            else:
                if Za[0] > Zb[0] and Za[P] == Zb[P]:
                    Rb = Ra.copy()
                    Zb = Za.copy()
                    ib = i
                    jb = j
            
    if ib != -1:
        k = 1
        F.X[int(F.Xs[ib])] = 0
        F.X[int(F.Xn[jb])] = 1
        aux = F.Xn[jb]
        F.Xn[jb] = F.Xs[ib]
        F.Xs[ib] = aux
        F.Z = Zb.copy()
        F.R = Rb.copy()

    return F, k


def N4(N,M,P,c,a,b,F,k,cputime,cp):
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    i1b = -1
    i2b = -1
    j1b = -1
    j2b = -1
    for i1 in range(1,int(F.Xs[0]+1)):
        for i2 in range(i1+1,int(F.Xs[0]+1)):
            for j1 in range(1,int(F.Xn[0]+1)):
                for j2 in range(j1+1,int(F.Xn[0]+1)):
                    Ra = np.zeros((M))
                    Za = np.zeros((P+1))
                    Za[0] = F.Z[0] - c[0][int(F.Xs[i1])] - c[0][int(F.Xs[i2])] + c[0][int(F.Xn[j1])] + c[0][int(F.Xn[j2])]
                    if Za[0] < Zb[0] and Zb[P] == 0:
                        continue
                    for m in range(M):
                        Ra[m] = F.R[m] - a[m][int(F.Xs[i1])] - a[m][int(F.Xs[i2])] + a[m][int(F.Xn[j1])] + a[m][int(F.Xn[j2])]
                        if Ra[m] > b[m]:
                            Za[P] = Za[P] + 1
                            if Za[P] > F.Z[P]:
                                break
                    if Za[P] < Zb[P]:
                        Rb = Ra.copy()
                        Zb = Za.copy()
                        i1b = i1
                        i2b = i2
                        j1b = j1
                        j2b = j2
                    else:
                        if Za[0] > Zb[0] and Za[P] == Zb[P]:
                            Rb = Ra.copy()
                            Zb = Za.copy()
                            i1b = i1
                            i2b = i2
                            j1b = j1
                            j2b = j2

                    if (time.time()-cputime) > cp*60:
                        break
                if (time.time()-cputime) > cp*60:
                    break
            if (time.time()-cputime) > cp*60:
                break
        if (time.time()-cputime) > cp*60:
            break
                    
    if i1b != -1:
        k = 1
        F.X[int(F.Xs[i1b])] = 0
        F.X[int(F.Xs[i2b])] = 0
        F.X[int(F.Xn[j1b])] = 1
        F.X[int(F.Xn[j2b])] = 1
        aux=F.Xn[j1b]
        F.Xn[j1b]=F.Xs[i1b]
        F.Xs[i1b]=aux
        aux=F.Xn[j2b]
        F.Xn[j2b]=F.Xs[i2b]
        F.Xs[i2b]=aux
        F.Z = Zb.copy()
        F.R = Rb.copy()
                        
    return F, k


def N5(N,M,P,c,a,b,F,k,cputime):
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    i1b = -1
    j1b = -1
    j2b = -1
    for i1 in range(1,int(F.Xs[0]+1)):
        for j1 in range(1,int(F.Xn[0]+1)):
            for j2 in range(j1+1,int(F.Xn[0]+1)):
                Ra = np.zeros((M))
                Za = np.zeros((P+1))
                Za[0] = F.Z[0] - c[0][int(F.Xs[i1])] + c[0][int(F.Xn[j1])] + c[0][int(F.Xn[j2])]
                if Za[0] < Zb[0] and Zb[P] == 0:
                    continue
                for m in range(M):
                    Ra[m] = F.R[m] - a[m][int(F.Xs[i1])] + a[m][int(F.Xn[j1])] + a[m][int(F.Xn[j2])]
                    if Ra[m] > b[m]:
                        Za[P] = Za[P] + 1
                        if Za[P] > F.Z[P]:
                            break
                if Za[P] < Zb[P]:
                    Rb = Ra.copy()
                    Zb = Za.copy()
                    i1b = i1
                    j1b = j1
                    j2b = j2
                else:
                    if Za[0] > Zb[0] and Za[P] == Zb[P]:
                        Rb = Ra.copy()
                        Zb = Za.copy()
                        i1b = i1
                        j1b = j1
                        j2b = j2
                
    if i1b != -1:
        k = 1
        F.X[int(F.Xs[i1b])] = 0
        F.X[int(F.Xn[j1b])] = 1
        F.X[int(F.Xn[j2b])] = 1
        aux=F.Xn[j1b]
        F.Xn[j1b]=F.Xs[i1b]
        F.Xs[i1b]=aux
        F.Xs[0]=F.Xs[0]+1
        F.Xs[int(F.Xs[0])]=F.Xn[j2b]
        F.Xn[0]=F.Xn[0]-1
        for h in range(j2b,int(F.Xn[0]+2)):
            F.Xn[h]=F.Xn[h+1]
        F.Z = Zb.copy()
        F.R = Rb.copy()
                    
#                        if (time.time()-cputime) > 5*60:
#                            break
#                if (time.time()-cputime) > 5*60:
#                    break
#        if (time.time()-cputime) > 5*60:
#            break

    return F, k


def N6(N,M,P,c,a,b,F,k,cputime):
    Rb = np.zeros((M))
    Zb = F.Z.copy()
    i1b = -1
    i2b = -1
    j1b = -1
    for i1 in range(1,int(F.Xs[0]+1)):
        for i2 in range(i1+1,int(F.Xs[0]+1)):
            for j1 in range(1,int(F.Xn[0]+1)):
                Ra = np.zeros((M))
                Za = np.zeros((P+1))
                Za[0] = F.Z[0] - c[0][int(F.Xs[i1])] - c[0][int(F.Xs[i2])] + c[0][int(F.Xn[j1])]
                if Za[0] < Zb[0] and Zb[P] == 0:
                    continue
                for m in range(M):
                    Ra[m] = F.R[m] - a[m][int(F.Xs[i1])] - a[m][int(F.Xs[i2])] + a[m][int(F.Xn[j1])]
                    if Ra[m] > b[m]:
                        Za[P] = Za[P] + 1
                        if Za[P] > F.Z[P]:
                            break
                if Za[P] < Zb[P]:
                    Rb = Ra.copy()
                    Zb = Za.copy()
                    i1b = i1
                    j1b = j1
                    i2b = i2
                else:
                    if Za[0] > Zb[0] and Za[P] == Zb[P]:
                        Rb = Ra.copy()
                        Zb = Za.copy()
                        i1b = i1
                        j1b = j1
                        i2b = i2
                
    if i1b != -1:
        k = 1
        F.X[int(F.Xs[i1b])] = 0
        F.X[int(F.Xs[i2b])] = 0
        F.X[int(F.Xn[j1b])] = 1
        aux=F.Xn[j1b]
        F.Xn[j1b]=F.Xs[i1b]
        F.Xs[i1b]=aux
        F.Xn[0]=F.Xn[0]+1
        F.Xn[int(F.Xn[0])]=F.Xs[i2b]
        F.Xs[0]=F.Xs[0]-1
        for j in range(i2b,int(F.Xs[0]+2)):
            F.Xs[j]=F.Xs[j+1]
        F.Z = Zb.copy()
        F.R = Rb.copy()
                
#                        if (time.time()-cputime) > 5*60:
#                            break
#                if (time.time()-cputime) > 5*60:
#                    break
#            if (time.time()-cputime) > 5*60:
#                break
#        if (time.time()-cputime) > 5*60:
#            break

    return F, k