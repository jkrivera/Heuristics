# -*- coding: utf-8 -*-

from xlrd import open_workbook
import xlsxwriter
import numpy as np
import time
from gurobipy import *


from solution_class import Solution
from reading import reading


for ins in range(1,2):
    
    print("---------- Instancia ",ins," ----------")
    print("")
    
    workbook = xlsxwriter.Workbook('JKRlns' + str(ins) + '.xlsx')
    
    MaxZ = []
    MaxZ.append(30909)
    MaxZ.append(28384)
    MaxZ.append(10688)
    MinZ = []
    MinZ.append(26215)
    MinZ.append(23726)
    MinZ.append(7224)
    w = []
    w.append(1)
    w.append(0.001)
    w.append(0.001)
    
    N, M, P, c, a, b = reading(ins)
    
    cputime = time.time()
    
    for w1 in range(11):
        for w2 in range(11):
            if w1+w2<=10:
                w=[]
                w.append(w1/10)
                w.append(w2/10)
                w.append((10-w1-w2)/10)
    
                # Model
                mod = Model("KSP")
                
                # Variables de decisión
                X = mod.addVars(N, vtype=GRB.BINARY, name="X")
                Z = mod.addVars(P, vtype=GRB.CONTINUOUS, name="Z")
                Y = mod.addVar(vtype=GRB.CONTINUOUS, name="Y")
            
                mod.setParam(GRB.Param.OutputFlag, 0)
            
                mod.update()
            
                name = "R1"
                for m in range(M):
                    mod.addConstr(quicksum(a[m][j]*X[j] for j in range(N) ) <= b[m], name=name)
                    
                name = "R2"
                for p in range(P):
                    mod.addConstr(Z[p] == quicksum(c[p][j]*X[j] for j in range(N)), name=name)
                    
                name = "R3"
                mod.addConstr(Y == quicksum(X[j] for j in range(N)), name=name)
            
                mod.setObjective(quicksum(w[p]*(Z[p]-MinZ[p])/(MaxZ[p]-MinZ[p]) for p in range(P)), GRB.MAXIMIZE)
                mod.setParam(GRB.Param.TimeLimit, 300)
                
                mod.update()
                mod.optimize()
                
            #    for j in range(N):
            #        if X[j].X>0.5:
            #            print("X[",j,"] = ", X[j].X)
            #    print("")
            #    print("Se eligieron ",Y.X," de ",N, " items")
            #    print("Hay ",M, " restricciones")
            #    print("")
            
            #    for p in range(P):
            #        print("Z[",p,"] = ", Z[p].X)
            #    print("")
                print(w,Z[0].X,Z[1].X,Z[2].X)
    
    print("t = %1.2f \t" % (time.time()-cputime))
    print("")
    print("")
    
    workbook.close()