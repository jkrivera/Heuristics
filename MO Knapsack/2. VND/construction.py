# -*- coding: utf-8 -*-
"""
Created on Fri Oct 30 17:58:10 2020

@author: jrivera6
"""
import numpy as np

from solution_class import Solution


def construction(N,M,P,c,a,b):

    X = np.zeros((N))
    
    R = np.zeros((M))
    
    Z = np.zeros((P+1))
    
    UB = np.zeros((P))
    for p in range(P):
        for j in range(N):
            if c[p][j] > 0:
                UB[p] = UB[p] + c[p][j]
    
    check = np.zeros((N))
    
    ap = np.zeros((M, N))
    
    fact = 0


# Find a feasible solution
    
    while sum(check) < N and fact == 0:
    
        Rp = np.zeros((N))
        Rn = np.ones((N))
        sel = -1
        for j in range(N):
            if check[j] == 0:
                for i in range(M):
                    ap[i][j] = a[i][j] / (b[i]-R[i]+0.001)
                    if b[i] >= 0 and R[i]+a[i][j] > b[i]:
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
            X[sel] = 1
            check[sel] = 1
            fact = 1
            for i in range(M):
                R[i] = R[i] + a[i][sel]
                if fact == 1 and R[i] > b[i]:
                    fact = 0
            for p in range(P):
                Z[p] = Z[p] + c[p][sel]
    

# Find a better solution
    
    while sum(check) < N and fact == 1:
    
        Rp = np.ones((N)) * np.Infinity
        sel = -1
        for j in range(N):
            if check[j] == 0:
                for p in range(P):
                    ap[p][j] = (UB[p]-Z[p])/UB[p]
                    if Rp[j] > ap[p][j]:
                        Rp[j] = ap[p][j]
                for i in range(M):
                    if R[i]+a[i][j] > b[i]:
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