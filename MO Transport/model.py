from gurobipy import *
import numpy as np



def MathModel(k, n, m, C, Dem, Cap, Sense, W, Zideal, Znadir, method):
    model = Model('Multiobjective Transport model')

    #%% Variables
    
    # X_ij = Number of products to transport from i to j
    X = model.addVars(n, m, vtype=GRB.CONTINUOUS, name='X')
    
    # Z_k = Value of objective k
    Z = model.addVars(k, vtype=GRB.CONTINUOUS, lb=-GRB.INFINITY, name='Z')
    
    # Dmax
    Dmax = model.addVar(vtype=GRB.CONTINUOUS, name='Dmax')
    
    model.update()
    
    
    #%% Constraints
    
    #%% Capacities
    
    model.addConstrs(quicksum(X[i,j] for j in range(m)) == Cap[i] for i in range(n))
    
    
    #%% Demands
    
    model.addConstrs(quicksum(X[i,j] for i in range(n)) == Dem[j] for j in range(m))
    
    
    #%% Objectives
    if method != 'prom0':
        for h in range(k):
            if Sense[h]==1:
                model.addConstr((quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)) - Zideal[h])/(Znadir[h]-Zideal[h]) == Z[h])
            else:
                model.addConstr((Zideal[h] - quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)))/(Zideal[h]-Znadir[h]) == Z[h])
    else:
        for h in range(k):
            if Sense[h]==1:
                model.addConstr(quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)) == Z[h])
            else:
                model.addConstr(quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)) == Z[h])

    if method == 'dist_inf':
        for h in range(k):
            
            if Sense[h]==1:
                model.addConstr(Dmax >= W[h]*(quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)) - Zideal[h])/(Znadir[h]-Zideal[h]))
            else:
                model.addConstr(Dmax >= W[h]*(Zideal[h] - quicksum(C[h][i][j]*X[i,j] for i in range(n) for j in range(m)))/(Zideal[h]-Znadir[h]))
                
    

    #%% Weighted objective
    if method == 'prom' or method == 'dist1':
        obj = quicksum(W[h]*Z[h] for h in range(k))
    if method == 'prom0':
        obj = quicksum(Sense[h]*W[h]*Z[h] for h in range(k))
    if method == 'dist_inf':
        obj = Dmax
    
    model.setObjective(obj, GRB.MINIMIZE)
    
    
    #%% Optimize
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    for h in range(k):
        print('Z[' + str(h) + "] = " + str(Z[h].X))
    print('Zw = ',model.objVal)
    print('-------------------------------------------')
    

def Data():
    k = 3  # Number of objectives
    n = 8  # number of origins
    m = 20 # number of destinations
    C = [[[61,28,63,82,87,36,37,66,45,49,64,81,97,81,95,80,35,29,31,50],[47,78,100,88,53,100,98,48,44,89,26,34,58,46,77,30,76,43,66,62],[59,27,50,99,77,53,57,59,43,100,38,76,84,71,74,90,87,76,46,32],[82,25,92,36,76,52,55,57,38,97,83,33,48,61,81,97,93,48,68,46],[31,33,56,79,85,56,31,91,68,97,100,74,96,90,97,75,30,95,48,87],[30,61,30,76,89,92,67,80,68,77,46,52,63,51,69,69,46,91,98,66],[48,59,60,53,71,85,66,70,97,57,57,27,46,52,40,60,64,50,48,65],[49,79,25,57,58,43,42,29,99,49,85,46,42,32,85,80,40,32,82,61]],[[4,2,2,1,3,4,4,1,4,4,5,0,2,4,2,3,3,3,2,2],[2,5,1,1,3,1,5,3,1,1,0,2,5,2,3,1,3,2,2,4],[2,5,4,5,4,4,5,4,0,1,2,3,5,4,3,5,1,3,0,5],[4,3,3,5,0,5,3,4,3,2,2,4,5,3,4,1,5,3,0,1],[0,4,5,2,2,1,0,3,1,5,1,5,1,5,0,2,5,2,5,3],[0,3,5,2,3,0,4,5,1,0,5,5,0,2,3,3,4,2,5,1],[2,3,3,3,4,1,4,5,3,2,2,5,2,0,1,0,1,3,5,3],[2,0,5,2,1,3,0,2,5,5,1,2,2,1,0,4,4,3,2,5]],[[5,-8,3,9,8,6,0,7,-9,7,-5,-7,-1,10,-6,7,-9,-9,8,10],[8,10,-9,-2,7,0,9,0,6,6,-8,5,7,3,2,0,4,0,-4,7],[8,0,1,3,7,-8,-4,-4,1,-8,9,0,8,-2,-4,-3,5,-1,4,4],[5,1,0,-7,6,0,8,10,-2,8,5,-6,-9,-1,6,-9,-2,-4,10,9],[-7,1,0,3,2,-1,-9,-6,-9,1,-8,-8,9,1,1,6,4,4,-4,8],[-10,-2,-1,-9,7,-6,3,-2,2,-8,7,7,-10,7,9,-3,2,-7,-2,-4],[6,9,-7,1,5,0,-6,-1,-1,2,-5,-1,7,9,-7,5,2,1,-4,10],[-10,-7,3,6,-5,-7,6,-5,-8,7,5,-2,-9,-4,5,-1,0,-6,1,10]]]
    Cap = [610,540,540,610,570,540,550,615]
    Dem = [275,300,150,125,150,275,275,125,125,225,225,300,275,300,275,300,150,250,225,250]
    Sense = [1,-1,1]
    
    return k, n, m, C, Dem, Cap, Sense


[k, n, m, C, Dem, Cap, Sense] = Data()

Zideal = [159965, 21540, -33840]
Znadir = [284850, 9780, 8295]

w=np.zeros(3)
h=0
method='prom' # 'prom' 'dist1' 'dist_inf'
for i in range(1):
    for j in range(4,5):
        if i+j<=10:
            h+=1
            w[0]=0.0001
            w[1]=j/10
            w[2]=(10-i-j)/10
            print(h)
            print(w)
            MathModel(k, n, m, C, Dem, Cap, Sense, w, Zideal, Znadir, method)
# w = [0, 0, 1]
# MathModel(k, n, m, C, Dem, Cap, Sense, w, Zideal, Znadir, method)