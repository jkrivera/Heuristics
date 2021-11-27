import numpy as np
import random
from gurobipy import *


from solution_class import Solution


def Rgreedy(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime):

    it = 0
    
    while it < 5:
        it = it + 1
        
        if it == 1:
            w = [0.9, 0.05, 0.05]
        if it == 2:
            w = [0.05, 0.9, 0.05]
        if it == 3:
            w = [0.05, 0.05, 0.9]
        if it >= 4:
            w = [random.random(), random.random(), random.random()]
            sw=sum(w)
            for i in range(P):
                w[i]=w[i]/sw
        
        X = Fp[0].X.copy()
        Xs = Fp[0].Xs.copy()
        Xn = Fp[0].Xn.copy()
        Z = Fp[0].Z.copy()
        R = Fp[0].R.copy()
        
        check = np.zeros((N))
        for i in range(int(Xs[0]+1)):
            check[int(Xs[i])] = 1
        
        ap = np.zeros((M, N))
        
        if Z[P] > 0:
            fact = 0
        else:
            fact = 1
        
        Xn = np.zeros((N+1))
    
    
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
                            Xn[0] = Xn[0] + 1
                            Xn[int(Xn[0])] = j
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
                Xs[0] = Xs[0] + 1
                Xs[int(Xs[0])] = sel
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
                    Rp[j] = 0
                    for p in range(P):
                        ap[p][j] = (Z[p]+c[p][j]-LB[p])/(UB[p]-LB[p])
                        Rp[j] = Rp[j] + w[p]*ap[p][j]
                    for i in range(M):
                        if R[i]+a[i][j] > b[i]:
                            check[j] = 1
                            Xn[0] = Xn[0] + 1
                            Xn[int(Xn[0])] = j
                            break
        
                    if check[j] == 0:
                        if sel == -1:
                            sel = j
                        else:
                            if Rp[j] > Rp[sel]:
                                sel = j
    
            if sel >= 0:                                
                X[sel] = 1
                Xs[0] = Xs[0] + 1
                Xs[int(Xs[0])] = sel
                check[sel] = 1
                fact = 1
                for i in range(M):
                    R[i] = R[i] + a[i][sel]
                    if fact == 1 and R[i] > b[i]:
                        fact = 0
                for p in range(P):
                    Z[p] = Z[p] + c[p][sel]
        
        Z[P] = 0
        for i in range(M):
            if R[i]>b[i]:
                Z[P] = Z[P] +1
                
        F.append(Solution(X,Xs,Xn,Z,R))
        ns = ns + 1

    return F, ns


def Rexact(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime):

    it = 0
    
    while it < 5:
        it = it + 1
        
        if it == 1:
            w = [0.9, 0.05, 0.05]
        if it == 2:
            w = [0.05, 0.9, 0.05]
        if it == 3:
            w = [0.05, 0.05, 0.9]
        if it >= 4:
            w = [random.random(), random.random(), random.random()]
            sw=sum(w)
            for i in range(P):
                w[i]=w[i]/sw
        
        X = Fp[0].X.copy()
        Xs = Fp[0].Xs.copy()
        Xn = Fp[0].Xn.copy()
        Z = Fp[0].Z.copy()
        R = Fp[0].R.copy()
        
        
        mod = Model("Opt_KSP")
        Xg = mod.addVars(N, vtype=GRB.BINARY, name="Xg")
        Zg = mod.addVars(P, vtype=GRB.CONTINUOUS, name="Zg")
        Pg = mod.addVars(M, lb=0, vtype=GRB.CONTINUOUS, name="Pg")

        mod.setParam(GRB.Param.OutputFlag, 0)

        mod.update()

        name = "c1"
        for m in range(M):
            mod.addConstr(quicksum(a[m][j]*Xg[j] for j in range(N) ) <= b[m] + quicksum(Pg[j] for j in range(M) ), name=name)
            
        name = "c2"
        for i in range(N):
            mod.addConstr(Xg[i] >= X[i], name=name)
            
        name = "c3"
        for p in range(P):
            mod.addConstr(Zg[p] == quicksum(c[p][j]*Xg[j] for j in range(N)), name=name)

        mod.setObjective(quicksum(w[p]*(Zg[p]-LB[p])/(UB[p]-LB[p]) for p in range(P)) - quicksum(Pg[m] for m in range(M)), GRB.MAXIMIZE)
        mod.setParam(GRB.Param.TimeLimit, 3)
        
        mod.update()
        mod.optimize()
        
        Xs = np.zeros((N+1))
        Xn = np.zeros((N+1))
        Z = np.zeros((P+1))
        R = np.zeros((M))
        for i in range(N):
            X[i] = Xg[i].X
            if X[i] >= 0.95:
                X[i] = 1
                Xs[0]=Xs[0]+1
                Xs[int(Xs[0])]=i
                for p in range(P):
                    Z[p] = Z[p] + c[p][i]
                for m in range(M):
                    R[m] = R[m] + a[m][i]
            else:
                X[i]=0
                Xn[0]=Xn[0]+1
                Xn[int(Xn[0])]=i
        Z[P] = 0
        for m in range(M):
            if R[m] > b[m]:
                Z[P] = Z[P] + 1
                
        F.append(Solution(X,Xs,Xn,Z,R))
        ns = ns + 1

    return F, ns


def Rexact2(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime):

    it = 0
    
    while it < 5:
        it = it + 1
        
        if it == 1:
            w = [0.9, 0.05, 0.05]
        if it == 2:
            w = [0.05, 0.9, 0.05]
        if it == 3:
            w = [0.05, 0.05, 0.9]
        if it >= 4:
            w = [random.random(), random.random(), random.random()]
            sw=sum(w)
            for i in range(P):
                w[i]=w[i]/sw
        
        X = Fp[0].X.copy()
        Xs = Fp[0].Xs.copy()
        Xn = Fp[0].Xn.copy()
        Z = Fp[0].Z.copy()
        R = Fp[0].R.copy()
        
        
        mod = Model("Opt_KSP")
        Xg = mod.addVars(N, vtype=GRB.BINARY, name="Xg")
        Zg = mod.addVars(P, vtype=GRB.CONTINUOUS, name="Zg")
        Pg = mod.addVars(M, lb=0, vtype=GRB.CONTINUOUS, name="Pg")

        mod.setParam(GRB.Param.OutputFlag, 0)
        mod.setParam(GRB.Param.TimeLimit, 3)

        mod.update()

        name = "c1"
        for m in range(M):
            mod.addConstr(quicksum(a[m][j]*Xg[j] for j in range(N) ) <= b[m] + quicksum(Pg[j] for j in range(M) ), name=name)
            
        name = "c2"
        for i in range(N):
            mod.addConstr(Xg[i] <= X[i], name=name)
            
        name = "c3"
        for p in range(P):
            mod.addConstr(Zg[p] == quicksum(c[p][j]*Xg[j] for j in range(N)), name=name)

        mod.setObjective(quicksum(w[p]*(Zg[p]-LB[p])/(UB[p]-LB[p]) for p in range(P)) - quicksum(Pg[m] for m in range(M)), GRB.MAXIMIZE)
        
        mod.update()
        mod.optimize()
        
        Xs = np.zeros((N+1))
        Xn = np.zeros((N+1))
        Z = np.zeros((P+1))
        R = np.zeros((M))
        for i in range(N):
            X[i] = Xg[i].X
            if X[i] >= 0.95:
                X[i] = 1
                Xs[0]=Xs[0]+1
                Xs[int(Xs[0])]=i
                for p in range(P):
                    Z[p] = Z[p] + c[p][i]
                for m in range(M):
                    R[m] = R[m] + a[m][i]
            else:
                X[i]=0
                Xn[0]=Xn[0]+1
                Xn[int(Xn[0])]=i
        Z[P] = 0
        for m in range(M):
            if R[m] > b[m]:
                Z[P] = Z[P] + 1
                
        F.append(Solution(X,Xs,Xn,Z,R))
        ns = ns + 1

    return F, ns