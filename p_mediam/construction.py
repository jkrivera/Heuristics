import numpy as np
import math
import copy

from gurobipy import *

from solution_class import Solution

def construction1(n,p,Q,q,d):

    # Vector that indicates if a node has been assigned    
    check = np.zeros((n))
    
    G=[]    # Clouster generator node
    Qk=[]   # Free capacity
    X=[]    # Assignment ¿?
    Y=[]    # Medians
    na=[]
    F=[]
    FT=0
    
    # Search the farther node to the closer one (ksel)
    nt=0
    for k in range(p):
        Qk.append(Q)
        if nt < n:
            hmin = []
            ksel=0
            for h in range(n):
                hmin.append(0)
                if check[h]==0:
                    for j in range(n):
                        if check[j]==0:
                            if d[h][j]!=0:
                                if d[h][hmin[h]]==0 or d[h][hmin[h]]>d[h][j]:
                                    hmin[h]=j
                    if h==0:
                        ksel = 0
                    else:
                        if d[h][hmin[h]]>d[ksel][hmin[ksel]]:
                            ksel=h
            
            G.append(ksel)
            check[ksel] = 1
            Qk[k] -= q[ksel]
            X.append([])
            X[k].append(ksel)
            nk = 1
            
            l = np.argsort(d[ksel][:])
            for j in range(n):
                if check[l[j]]==0:
                    if Qk[k] - q[l[j]] < 0:
                        break
                    else:
                    
                        X[k].append(l[j])
                        Qk[k] -= q[l[j]]
                        nk += 1      
                        check[l[j]]=1
            
            Dm = []
            sel = 0
            for i in range(nk):
                Dm.append(0)
                for j in range(nk):
                    Dm[i]+=d[X[k][i]][X[k][j]]
                if Dm[i]<Dm[sel]:
                    sel=i
            
            Y.append(X[k][sel])
            F.append(Dm[sel])
            na.append(nk)
            nt += nk
            
            FT += F[k]
            
        else:
            na.append(0)
            Y.append([])
            X.append([])
            F.append(0)
    
    while nt != n:
        seli = -1
        for i in range(n):
            if check[i]==0:
                if seli<0 or q[i]>q[seli]:
                    seli=i
        i=i
        
    print("Constructive 1")
    print(FT)
    Sol = Solution(X, Y, Qk, F, na, FT)
    
    return Sol


def construction2(n,p,Q,q,d,par):

    Qpar = Q*par    

    # Vector that indicates if a node has been assigned    
    check = np.zeros((n))
    
    G=[]    # Clouster generator node
    Qk=[]   # Free capacity
    X=[]    # Assignment ¿?
    Y=[]    # Medians
    na=[]
    F=[]
    FT=0
    
    # Search the farther node to the closer one (ksel)
    for k in range(p):
        Qk.append(Qpar)
        hmin = []
        ksel=0
        for h in range(n):
            hmin.append(0)
            if check[h]==0:
                for j in range(n):
                    if check[j]==0:
                        if d[h][j]!=0:
                            if d[h][hmin[h]]==0 or d[h][hmin[h]]>d[h][j]:
                                hmin[h]=j
                if h==0:
                    ksel = 0
                else:
                    if d[h][hmin[h]]>d[ksel][hmin[ksel]]:
                        ksel=h
        
        G.append(ksel)
        check[ksel] = 1
        Qk[k] -= q[ksel]
        X.append([])
        X[k].append(ksel)
        nk = 1
        
        l = np.argsort(d[ksel][:])
        for j in range(n):
            if Qk[k] - q[l[j]] < 0:
                break
            else:
                if check[l[j]]==0:
                    X[k].append(l[j])
                    Qk[k] -= q[l[j]]
                    nk += 1      
                    check[l[j]]=1
        
        # while Qk[k] < Q*(1-par):
        #     check[X[k][nk]]=0
        #     Qk[k] += q[X[k][nk]]
        #     nk -= 1
            
        
        Dm = []
        sel = 0
        for i in range(nk):
            Dm.append(0)
            for j in range(nk):
                Dm[i]+=d[X[k][i]][X[k][j]]
            if Dm[i]<Dm[sel]:
                sel=i
        
        Y.append(X[k][sel])
        F.append(Dm[sel])
        na.append(nk)
        
        FT += F[k]
    
    na,Y,Qk,F,X,FT = MathModel1(na,Y,Qk,F,X,n,p,Q,q,d)
    
    print("Constructive 2")
    print(FT)
    Sol = Solution(X, Y, Qk, F, na, FT)
    
    return Sol


def construction3(n,p,Q,q,d,par):

    Qpar = Q*par    

    # Vector that indicates if a node has been assigned    
    check = np.zeros((n))
    
    G=[]    # Clouster generator node
    Qk=[]   # Free capacity
    X=[]    # Assignment ¿?
    Y=[]    # Medians
    na=[]
    F=[]
    FT=0
    
    # Search the farther node to the closer one (ksel)
    nt=0
    for k in range(p):
        Qk.append(Q)
        if nt!=n:
            hmin = []
            ksel=0
            for h in range(n):
                hmin.append(0)
                if check[h]==0:
                    for j in range(n):
                        if check[j]==0:
                            if d[h][j]!=0:
                                if d[h][hmin[h]]==0 or d[h][hmin[h]]>d[h][j]:
                                    hmin[h]=j
                    if h==0:
                        ksel = 0
                    else:
                        if d[h][hmin[h]]>d[ksel][hmin[ksel]]:
                            ksel=h
            
            G.append(ksel)
            check[ksel] = 1
            Qk[k] -= q[ksel]
            X.append([])
            X[k].append(ksel)
            nk = 1
            
            l = np.argsort(d[ksel][:])
            for j in range(n):
                if Qk[k] - q[l[j]] < 0:
                    break
                else:
                    if check[l[j]]==0:
                        X[k].append(l[j])
                        Qk[k] -= q[l[j]]
                        nk += 1      
                        check[l[j]]=1
            
            Dm = []
            sel = 0
            for i in range(nk):
                Dm.append(0)
                for j in range(nk):
                    Dm[i]+=d[X[k][i]][X[k][j]]
                if Dm[i]<Dm[sel]:
                    sel=i
            
            Y.append(X[k][sel])
            F.append(Dm[sel])
            na.append(nk)
            nt += nk
            
            FT += F[k]
        else:
            na.append(0)
            X.append([])
            Y.append([])
            
    for k in range(p):
    
        while Qk[k] < Q*(1-par):
            check[X[k][na[k]-1]]=0
            Qk[k] += q[X[k][na[k]-1]]
            na[k] -= 1
        
    Yc = copy.deepcopy(Y)
    Xc = copy.deepcopy(X)
    nac = copy.deepcopy(na)
    
    print("Constructive 3")
    print(n-sum(na))
    nc=0
    for k in range(p):
        if nac[k]==0:
            nc += 1
    if nc <= n-sum(na):
        print("Model")
        na,Y,Qk,F,X,FT = MathModel1(na,nac,Yc,Qk,F,Xc,n,p,Q,q,d)
    
    print(FT)
    Sol = Solution(X, Y, Qk, F, na, FT)
    
    return Sol


def MathModel1(na,nac,Y,Qk,F,X,n,p,Q,q,d):
    
    ## SETS
    
    # Set of sets
    K = [i for i in range(p)]
    
    # Set of nodes
    N = [i for i in range(n)]
    
    ## PARAMETERS
    
    # Pre-assigned nodes
    w = check = np.zeros((n,p))
    for k in range(p):
        for i in range(na[k]):
            w[X[k][i]][k] = 1
    
    ## MODEL
    mod = Model("pmedcap1")
    
    ## DECISION VARIABLES
    varX = mod.addVars(n, p, vtype=GRB.BINARY, name='X')  # X_ik = 1 if node i is assigned to set k
    varY = mod.addVars(n, p, vtype=GRB.BINARY, name='Y')  # Y_ik = 1 if node i is median of set k
    varZ = mod.addVars(n, n, p, vtype=GRB.BINARY, name='Z')  # Z_ijk = 1 if node i is matched to median j for set k
    
    mod.update()
    
    ## OBJECTIVE FUNCTION
    mod.setObjective(quicksum(d[i][j]*varZ[i, j, k] for i in N for j in N for k in K), GRB.MINIMIZE)
    
    ## CONSTRAINTS
    
    ## Assignment
    
    # Equation 1
    for i in N:
        mod.addConstr(quicksum((w[i][k]+varX[i,k]) for k in K) == 1)
        
    # Equation 1 - SOS
    for i in N:
        mod.addSOS(GRB.SOS_TYPE1, [varX[i,k] for k in K])
    
    # Equation 2
    for i in N:
        mod.addConstr(quicksum(varX[i,k] for k in K) <= 1 - quicksum(w[i][k] for k in K))
    
    # Equation 3
    for k in K:
        mod.addConstr(quicksum(q[i]*(w[i][k]+varX[i,k]) for i in N) <= Q)
            
    # Equation 4
    for i in N:
        for k in K:    
            mod.addConstr(varY[i,k] <= w[i][k]+varX[i,k])
    
    # Equation 5
    for k in K:
        mod.addConstr(quicksum(varY[i,k] for i in N) == 1)
        
    # for k in K:
    #     mod.addConstr(quicksum(varY[i,k] for i in N) >= quicksum(varX[i,k]/n for i in N))
    
    # Equation 5 - SOS
    for k in K:
        mod.addSOS(GRB.SOS_TYPE1, [varY[i,k] for i in N])

    # Equation 6
    for i in N:
        for j in N:
            for k in K:
                mod.addConstr(varZ[i,j,k] >= w[i][k]+varX[i,k]+varY[j,k]-1)
    
    # Starting solution
    for k in K:
        if nac[k]>0:
            varY[Y[k],k].Start = 1
    
    for k in K:
        for i in range(nac[k]):
            varX[X[k][i],k].Start = 1
                
    for k in K:
        if nac[k]>0:
            for i in range(nac[k]):
                varZ[X[k][i],Y[k],k].Start = 1

    ## SOLVE
    
    mod.setParam(GRB.Param.OutputFlag, 0)
    mod.setParam(GRB.Param.TimeLimit, 300)
    
    mod.update()
    
    mod.optimize()
    
    na=[]
    Y=[]
    Qk=[]
    F=[]
    X=[]
    for k in range(p):
        Qk.append(Q)
        na.append(0)
        F.append(0)
        X.append([])
        for j in range(n):
            if varY[j,k].X > 0.9:
                na[k] += 1
                Y.append(j)
                Qk[k] -= q[j]
                X[k].append(j)
                for i in range(n):
                    if varZ[i,j,k].X > 0.9:
                        if i!=j:
                            na[k] += 1
                            Qk[k] -= q[i]
                            X[k].append(i)
    obj = mod.getObjective()
    FT=obj.getValue()
    
    return na,Y,Qk,F,X,FT