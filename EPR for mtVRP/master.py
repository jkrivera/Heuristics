#%%   ##############################################################################

import math
import numpy as np
import pandas as pd
import openpyxl
import os
import random
import time

from gurobipy import *

#%%   READING EXPERIMENTS
def reading_exp(exp):
    with open('Instances/' + exp + '.txt') as f:
        lines = f.readlines()
    ninst = len(lines)
    for i in range(ninst):
        lines[i] = lines[i].replace("\n","")
        
    with open('Instances/Results/result_index.txt') as f:
        ln = f.readlines()
    nexp = int(ln[0])
    return lines, nexp


#%%   PROBLEM OBJECT
class Problem:
  def __init__(self, V, Vp, n, R, Q, Th, q, d, dv, sd, pen, dg):
    self.V = V         # set of nodes
    self.Vp= Vp        # set of demand nodes
    self.n = n         # number of nodes
    self.R = R         # number of vehicles
    self.Q = Q         # Vehicle capacity
    self.Th= Th        # multitrip length limit
    self.q = q         # demand
    self.d = d         # distances
    self.dv = dv       # numer of decision variables
    # Precomputings
    self.sd = sd       # sorted distances
    self.pen = pen     # penalty cost
    self.dg = dg
    
    
#%%   PARAMETERS OBJECT
class parameters_def:
  def __init__(self, npop,nvar,tl,gmax,nsol,soltype):
    self.npop = int(npop)        # population size
    self.nvar = int(nvar)        # number of variables
    self.TimeLimit = tl          # time limit
    self.gmax = int(gmax)        # maximum number of generations
    self.nsol = int(nsol)        # maximum number of solutions
    self.soltype = soltype       # solution type
    

#%%   SOLUTION OBJECT
class solution:
  def __init__(self, P, seq, r, Qk, nnodes, routes, rdist, Assign, Vth, Zv, Zf, g):
    self.P       = P        # random key values
    self.seq     = seq      # sequence of nodes
    self.r       = r        # number of routes
    self.Qk      = Qk       # load limit of each route
    self.nnodes  = nnodes   # number of nodes on each routes
    self.routes  = routes   # routes
    self.rdist   = rdist    # distance of each route
    self.Assign  = Assign   # assignment of each route to vehicles
    self.Vth     = Vth      # violation on each route
    self.Zv      = Zv       # violation objective
    self.Zf      = Zf       # distance objective
    self.g       = g        # generation
    

#%%   READING INSTANCE DATA
def reading(ins,gnr,soltype):

    file = 'Instances/' + ins
    with open(file) as f:
        lines = f.readlines()
    
    line = lines[0].split('\t')
    line[3] = line[3].replace('\n','')
    n  = int(line[0])
    R  = int(line[1])
    Q  = int(line[2])
    Th = int(line[3])
    
    V = range(n+1)
    Vp= range(1,n+1)
    
    coord = np.zeros((n+1,2))
    q = np.zeros(n+1)
    for i in V:
        line = lines[i+1].split('\t')
        coord[i][0] = int(line[1])
        coord[i][1] = int(line[2])
        line[3] = line[3].replace('\n','')
        q[i] = int(line[3])
    
    d=np.zeros((n+1,n+1))
    dg=np.zeros((n+1,n+1))
    pen=0
    for i in range(n+1):
        d[i][i] = math.inf
        dg[i][i] = math.inf
        for j in range(i+1,n+1):
            d[i][j] = math.sqrt((coord[i][0] - coord[j][0])**2 + ((coord[i][1] - coord[j][1])**2))
            d[j][i] = d[i][j]
            dg[i][j] = math.sqrt((coord[i][0] - coord[j][0])**2 + ((coord[i][1] - coord[j][1])**2))
            dg[j][i] = dg[i][j]
            pen += d[j][i]
    aux = math.ceil(gnr*n)
    for i in range(1,n+1):
        ds = np.argsort(dg[i])
        for j in range(aux,n+1):
            dg[i][ds[j]] = math.inf
    
    sd=[]
    for i in range(n):
        sd.append(np.argsort(d[i][:]))
    
    if soltype == 'onlyRK':
        problem = Problem(V,Vp,n,R,Q,Th,q,d,2*n,sd,pen,dg)
    if soltype == 'RK+split':
        problem = Problem(V,Vp,n,R,Q,Th,q,d,n,sd,pen,dg)
    
    return problem


#%%   EXPERIMENTS INFORMATION
exp = 'exp1'
instances, nexp = reading_exp(exp)


#%%   PARAMETERS
print('-------------------------------------------------------------------------')
print('Parameters:')
npop  = 20        # Número de soluciones
tl    = 300       # Time Limit
gmax  = 500  # maximum number of generations
nsol  = 10000000  # maximum number of solutions
gnr   = 0.1       # granularity
maxg  = 20        # max number of survival generations
soltype = 'RK+split' # 'RK+split' 'onlyRK'#

print("npop","\t",npop)
print("tlim","\t",tl)
print("gmax","\t",gmax)
print("nsol","\t",nsol)
print("gnlr","\t",gnr)
print("maxg","\t",maxg)
print('-------------------------------------------------------------------------')


#%%   SEQUENCING
def sequencing(P,problem):
    seq = np.argsort(P[:problem.n])+1
    for i in range(len(seq)):
        for j in range(i+1,len(seq)):
            if problem.dg[seq[i]][seq[j]] < math.inf:
                if j==i+1:
                    break
                else:
                    aux=seq[j]
                    for k in range(j,i+1,-1):
                        seq[k] = seq[k-1]
                    seq[i+1] = aux
                    break
    return seq


#%%   DECODING
def decoding(problem,params,P,g):
    if params.soltype == 'onlyRK':
        S = decoding_2RK(problem,params,P,g)
    if params.soltype == 'RK+split':
        S = decoding_RKsplit(problem,params,P,g)
    return S
    
    
def decoding_2RK(problem,params,P,g):
    seq = sequencing(P[:problem.n],problem)
    # Qk = np.ceil(P[problem.n:]*problem.Q)
    Qk = np.ceil((P[problem.n:]**(1/2))*problem.Q)
    # Qk = np.ceil((P[problem.n:]**(1/3))*problem.Q)
    
    dmax = 0
    for i in range(problem.n+1):
        for j in range(problem.n+1):
            if dmax < problem.d[i][j] and i!=j:
                dmax = problem.d[i][j]
    
    h = -1
    r = -1
    routes=[]
    rdist=[]
    nnodes=[]
    Zf = 0
    while h < problem.n-1:
        load = 0
        r += 1
        routes.append([0])
        rdist.append(0)
        while load < max(Qk[r],1):
            if load + problem.q[seq[h+1]] <= problem.Q:
                h += 1
                routes[r].append(seq[h])
                load += problem.q[seq[h]]
                rdist[r] += problem.d[routes[r][len(routes[r])-2],routes[r][len(routes[r])-1]]
                if h == problem.n-1:
                    break
            else:
                break
        nnodes.append(len(routes[r])-1)
        routes[r].append(0)
        rdist[r] += problem.d[routes[r][len(routes[r])-2],routes[r][len(routes[r])-1]]
        if rdist[r] > dmax*problem.n:
            r=r
        Zf += rdist[r]
        
    Assign, VTh, Zv = Scheduling_Optimizer(r+1,routes,rdist,problem)
    
    S = solution(P,seq,r+1,Qk,nnodes,routes,rdist,Assign,VTh,Zv,Zf,g)
    
    return S


def decoding_RKsplit(problem,params,P,g):
    seq = sequencing(P,problem)
    seq = list(seq)
    seq.insert(0,0)

    V = np.ones(problem.n+1)*math.inf
    p = np.zeros(problem.n+1)
    V[0] = 0
    for i in range(1,problem.n+1):
        j = i
        load = 0
        cost = 0
        while j <= problem.n and load <= problem.Q and cost <= problem.Th:
            load += problem.q[seq[j]]
            if i == j:
                cost = problem.d[0][seq[i]] + problem.d[seq[i]][0]
            else:
                cost += -problem.d[seq[j-1]][0] + problem.d[seq[j-1]][seq[j]] + problem.d[seq[j]][0]
            if load <= problem.Q and V[i-1] + cost < V[j] and cost <= problem.Th:
                V[j] = V[i-1] + cost
                p[j] = i-1
            j += 1
    
    routes=[]
    rdist=[]
    nnodes=[]
    r = -1
    h = problem.n
    while h > 0:
        r += 1
        routes.append([0])
        nnodes.append(int(h-p[h]))
        for i in range(int(p[h])+1,h+1):
            routes[r].append(seq[i])
        routes[r].append(0)
        rdist.append(0)
        for i in range(nnodes[r]+1):
            rdist[r] += problem.d[routes[r][i]][routes[r][i+1]]
        h = int(p[h])
    
    Zf = sum(rdist)
        
    Assign, VTh, Zv = Scheduling_Optimizer(r+1,routes,rdist,problem)
    
    S = solution(P,seq,r+1,problem.Q,nnodes,routes,rdist,Assign,VTh,Zv,Zf,g)
    
    return S
        

#%%   INITIAL POPULATION
def Initial_Population(GAparam):
    
    P = []
    
    for i in range(GAparam.npop):
        P.append(np.random.random(int(GAparam.nvar)))
    
    return P


#%%   SCHEDULING MODEL
def Scheduling_Optimizer(r,routes,rdist,problem):
    model = Model('Scheduling')
    X = model.addVars(r, problem.R, vtype=GRB.BINARY, name='X')  # 1 if route k is assigned to vehicle h
    V = model.addVars(problem.R, vtype=GRB.CONTINUOUS, name='V') # grade of violationin route k
    
    setR = range(problem.R) # set of vehicles
    setP = range(r)         # set of routes
    
    model.addConstrs(quicksum(X[k,h] for h in setR) == 1 for k in setP)
    
    model.addConstr(X[0,0] == 1)
    
    model.addConstrs(V[h] >= quicksum(rdist[k]*X[k,h] for k in setP) - problem.Th for h in setR)
    
    model.setObjective(quicksum(V[h] for h in setR), GRB.MINIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    Assign = []
    VTh = []
    for h in setR:
        Assign.append([])
        VTh.append(V[h].X)
        for k in setP:
            if X[k,h].X > 0.1:
                Assign[h].append(k)
                
    
    return Assign, VTh, model.objVal


def Selection_Scheduling(nr,routes,rdist,Cov,problem):
    model = Model('Scheduling')
    Y = model.addVars(nr, vtype=GRB.BINARY, name='Y')
    X = model.addVars(nr, problem.R, vtype=GRB.BINARY, name='X')  # 1 if route k is assigned to vehicle h
    V = model.addVars(problem.R, vtype=GRB.CONTINUOUS, name='V') # grade of violationin route k
    
    setK = range(problem.R) # set of vehicles
    setR = range(nr)         # set of routes
    setN = range(1,problem.n+1)
    
    model.addConstrs(quicksum(Cov[r][i]*Y[r] for r in setR) == 1 for i in setN)
    
    model.addConstrs(quicksum(X[r,k] for k in setK) == Y[r] for r in setR)
    
    model.addConstrs(V[k] >= quicksum(rdist[r]*X[r,k] for r in setR) - problem.Th for k in setK)
    
    model.setObjective(quicksum(V[k] for k in setK), GRB.MINIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    Assign = []
    VTh = []
    Zf = 0
    for k in setK:
        Assign.append([])
        VTh.append(V[k].X)
        for r in setR:
            if X[r,k].X > 0.1:
                Assign[k].append(r)
                Zf += rdist[r]
    
    Zv = sum(VTh)
                
    return Assign, VTh, Zv, Zf


def Selection_Scheduling2(routes,BC,problem):
    
    Cov = []
    for k in range(len(routes)):
        Cov.append(np.zeros(problem.n+1))
        for i in range(1,len(routes[k])-1):
            Cov[k][routes[k][i]] = 1

    r=0
    rlim = len(routes)
    while r < rlim:
        n = len(routes[r])
        c1 = 0
        r1 = [0, 0]
        cov1 = np.zeros(problem.n+1)
        c2 = BC[r] - problem.d[0][routes[r][1]]
        cov2 = Cov[r].copy()
        for i in range(1,n-2):
            
            r1.insert(i,routes[r][i])
            c1 += problem.d[routes[r][i-1]][routes[r][i]]
            cov1[routes[r][i]] = 1
            routes.append(r1.copy())
            BC.append(c1+problem.d[r1[i]][0])
            Cov.append(cov1.copy())
            
            routes.append(routes[r][i+1:n+1])
            routes[len(routes)-1].insert(0,0)
            c2 += -problem.d[routes[r][i]][routes[r][i+1]]
            BC.append(c2 + problem.d[0][routes[r][i+1]])
            cov2[routes[r][i]] = 0
            Cov.append(cov2.copy())
            
        r += 1
    
    model = Model('Scheduling')
    Y = model.addVars(len(routes), vtype=GRB.BINARY, name='Y')
    X = model.addVars(len(routes), problem.R, vtype=GRB.BINARY, name='X')  # 1 if route k is assigned to vehicle h
    V = model.addVars(problem.R, vtype=GRB.CONTINUOUS, name='V') # grade of violationin route k
    
    setK = range(problem.R) # set of vehicles
    setR = range(len(routes))         # set of routes
    setN = range(1,problem.n+1)
    
    model.addConstrs(quicksum(Cov[r][i]*Y[r] for r in setR) == 1 for i in setN)
    
    model.addConstrs(quicksum(X[r,k] for k in setK) == Y[r] for r in setR)
    
    model.addConstrs(V[k] >= quicksum(BC[r]*X[r,k] for r in setR) - problem.Th for k in setK)
    
    model.setObjective(quicksum(V[k] for k in setK), GRB.MINIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    if model.objVal == 0:
    
        model2 = Model('Scheduling')
        Y2 = model2.addVars(len(routes), vtype=GRB.BINARY, name='Y2')
        X2 = model2.addVars(len(routes), problem.R, vtype=GRB.BINARY, name='X2')  # 1 if route k is assigned to vehicle h
        V2 = model2.addVars(problem.R, vtype=GRB.CONTINUOUS, name='V2') # grade of violationin route k
        
        model2.addConstrs(quicksum(Cov[r][i]*Y2[r] for r in setR) == 1 for i in setN)
        
        model2.addConstrs(quicksum(X2[r,k] for k in setK) == Y2[r] for r in setR)
        
        model2.addConstrs(quicksum(BC[r]*X2[r,k] for r in setR) <= problem.Th   for k in setK)
        
        model2.setObjective(quicksum(BC[r]*Y2[r] for r in setR), GRB.MINIMIZE)
        
        model2.setParam(GRB.Param.OutputFlag,0)
        model2.optimize()

        Broutes = []
        Assign = []
        VTh = []
        Zf = 0
        for k in setK:
            Assign.append([])
            VTh.append(V2[k].X)
            for r in setR:
                if X2[r,k].X > 0.1:
                    Assign[k].append(r)
                    Zf += BC[r]
                    Broutes.append(routes[r])
        
        Zv = sum(VTh)

    else:
        
        Broutes = []
        Assign = []
        VTh = []
        Zf = 0
        for k in setK:
            Assign.append([])
            VTh.append(V[k].X)
            for r in setR:
                if X[r,k].X > 0.1:
                    Assign[k].append(r)
                    Zf += BC[r]
                    Broutes.append(routes[r])
        
        Zv = sum(VTh)
                
    return Broutes, Assign, VTh, Zv, Zf


#%%   IMPROVING PROCEDURE
def improve(problem,params,P):
     B = S
     for r in P.r:
         V = S


#%%   NEW SOLUTION
def NewSolution(i,j,S,params):
    H = []
    wi = random.random()*3-1
    wj = 1-wi
    for k in range(params.nvar):
        H.append(wi*S[i].P[k]+wj*S[j].P[k])
    
    aux = min(H)
    H = H-aux
    
    aux = max(H)
    H = H/aux
        
    return H


#%%   UPDATING
def Updating(S,problem,params,maxg):
    d = np.zeros((len(S),len(S)))
    dmax=0
    for i in range(len(S)):
        for j in range(len(S)):
            if i != j:
                for k in range(problem.dv):
                    d[i][j] += (S[i].P[k]-S[j].P[k])**2
            if dmax < d[i][j]:
                dmax = d[i][j]
                    
    sel = 0
    for k in range(len(S)):
        if (S[sel].Zv > S[k].Zv) or (S[sel].Zv == S[k].Zv and S[sel].Zf > S[k].Zf):
            sel = k
    # print(S[sel].Zv,'\t',S[sel].Zf)
    
    model = Model('Updating')
    X = model.addVars(len(S), vtype=GRB.BINARY, name='X')  # 1 if solution k is selected
    
    D = model.addVar(vtype=GRB.CONTINUOUS, name='D')  # 
    
    setS = range(len(S)) # set of solutins
    
    model.addConstr(quicksum(X[k] for k in setS) == params.npop)
    
    model.addConstr(X[sel] == 1)
    
    for i in setS:
        if i!=sel:
            if S[i].g <= maxg:
                model.addConstr(X[i] == 0)
    
    model.addConstrs(D <= d[i][j] + dmax*(1-X[i]) for i in setS for j in setS if i!=j)
    model.addConstrs(D <= d[i][j] + dmax*(1-X[j]) for i in setS for j in setS if i!=j)
    
    model.setObjective(D, GRB.MAXIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    sel = np.zeros(len(S))
    for k in range(len(S)-1,-1,-1):
        if X[k].X < 0.1:
            S.remove(S[k])
    
    return S


#%%   ROUTE SET DECOMPOSITION
def Decomp(S,RouteSet):
    h = 0
    for k in range(S.r):
        rlim = len(RouteSet)-k+h
        RouteSet.append([S.routes[k],S.rdist[k],sum(problem.q[S.routes[k]]),S.nnodes[k],sum(S.routes[k]),np.zeros(problem.n+1)]) # route, cost/dist, nr nodes, sum indexes
        for i in range(1,len(RouteSet[len(RouteSet)-1][0])-1):
            RouteSet[len(RouteSet)-1][5][RouteSet[len(RouteSet)-1][0][i]] = 1
        
        r = 0
        while r < rlim:
            if RouteSet[r][4] == RouteSet[rlim+k-h][4]:
                if sum(abs(RouteSet[r][5]-RouteSet[rlim+k-h][5]))==0:
                    if RouteSet[r][1] < RouteSet[rlim+k-h][1]:
                        RouteSet.remove(RouteSet[rlim+k-h])
                        h += 1
                        break
                    else:
                        RouteSet.remove(RouteSet[r])
                        rlim -= 1
                        break
            r += 1
    
    return RouteSet
        

#%%   POSTOPTIMIZATION
def PostOptimization(RouteSet,problem):
    Covering = np.zeros((len(RouteSet),problem.n+1))
    C = []
    for r in range(len(RouteSet)):
        for i in range(1,len(RouteSet[r][0])-1):
            Covering[r][RouteSet[r][0][i]] = 1
        C.append(RouteSet[r][1])
            

    model = Model('SetPartitioning')
    X = model.addVars(len(RouteSet), vtype=GRB.BINARY, name='X')  # 1 if solution k is selected
    
    setS = range(len(RouteSet)) # set of routes
    setN = range(1,problem.n+1)
    
    model.addConstrs(quicksum(Covering[r][i]*X[r] for r in setS) == 1 for i in setN)
    
    model.setObjective(quicksum(C[r]*X[r] for r in setS), GRB.MINIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    nr = 0
    routes = []
    rdist = []
    for r in setS:
        if X[r].X > 0.1:
            nr += 1
            routes.append(RouteSet[r][0])
            rdist.append(C[r])
            # print(r,'\t',C[r],'\t',RouteSet[r][0])
            
    Assign, VTh, Zv = Scheduling_Optimizer(nr,routes,rdist,problem)

    return routes,Assign,Zv,model.objVal


#%%   POSTOPTIMIZATION 2
def PostOptimization2(RouteSet,problem,nsol):
    Covering = np.zeros((len(RouteSet),problem.n+1))
    C = []
    for r in range(len(RouteSet)):
        for i in range(1,len(RouteSet[r][0])-1):
            Covering[r][RouteSet[r][0][i]] = 1
        C.append(RouteSet[r][1])
            

    model = Model('SetPartitioning')
    X = model.addVars(len(RouteSet), nsol, vtype=GRB.BINARY, name='X')  # 1 if solution k is selected
    
    setS = range(len(RouteSet)) # set of routes
    setN = range(1,problem.n+1)
    
    model.addConstrs(quicksum(Covering[r][i]*X[r,s] for r in setS) == 1 for i in setN for s in range(nsol))
    
    model.addConstrs(quicksum(X[r,s] for s in range(nsol)) <= 1 for r in setS)
    
    # model.addConstrs( sum(abs(Covering[r1]-Covering[r2])) >= quicksum((X[r2,s]+X[r1,s]) for s in range(nsol)) - 1 for r1 in setS for r2 in setS if r1>r2)
    for r1 in setS:
        for r2 in setS:
            if r1>r2:
                coeff = sum(abs(Covering[r1]-Covering[r2]))
                if coeff == 0:
                    # model.addConstr( quicksum((X[r2,i]+X[r1,i]) for i in range(nsol)) <= 1 )
                    if C[r1] >= C[r2]:
                        model.addConstr( quicksum(X[r1,i] for i in range(nsol)) == 0 )
                    else:
                        model.addConstr( quicksum(X[r2,i] for i in range(nsol)) == 0 )
                    
    
    model.setObjective(quicksum(C[r]*X[r,s] for r in setS for s in range(nsol)), GRB.MINIMIZE)
    
    model.setParam(GRB.Param.OutputFlag,0)
    model.optimize()
    
    nr = 0
    routes = []
    rdist = []
    Cov = []
    for s in range(nsol):
        for r in setS:
            if X[r,s].X > 0.1:
                nr += 1
                routes.append(RouteSet[r][0])
                rdist.append(C[r])
                Cov.append(Covering[r])
                # print(s,'\t',r,'\t',C[r],'\t',RouteSet[r][0])
    
    routes, rdist = k_TSP2(routes,problem)
    
    Assign, VTh, Zv, Zf = Selection_Scheduling(nr,routes,rdist,Cov,problem)
    
    return routes, Assign, VTh, Zv, Zf


#%%   k-TSP
def k_TSP(routes,problem):

    nr = 0
    iroutes = []
    rdist = []
    Zf = 0

    for r in range(len(routes)):    

        model = Model('TSP')
        X = model.addVars(problem.n+1,problem.n+1, vtype=GRB.BINARY, name='X')  # 1 if arc (i,j) is traversed
        y = model.addVars(problem.n+1,problem.n+1, vtype=GRB.CONTINUOUS, name='y')  # 1 if arc (i,j) is traversed
        
        setN = routes[r][0:-1]
        
        model.addConstrs(quicksum(X[i,j] for i in setN if i!=j) == 1 for j in setN)
        
        model.addConstrs(quicksum(X[i,j] for j in setN if i!=j) == 1 for i in setN)
        
        model.addConstrs(X[i,i] == 0 for i in range(problem.n+1))
        
        model.addConstrs(y[i,j] <= len(setN)*X[i,j] for i in setN for j in setN)
        
        model.addConstrs(quicksum(y[j,i]-y[i,j] for j in setN if i!=j) == 1 for i in setN if i!=0)
        
        model.setObjective(quicksum(problem.d[i][j]*X[i,j] for i in setN for j in setN if i!=j), GRB.MINIMIZE)
        
        model.setParam(GRB.Param.OutputFlag,0)
        model.optimize()
        
        nr += 1
        iroutes.append([])
        rdist.append(model.objVal)
        Zf += model.objVal
        i=0
        j=1
        iroutes[r].append(0)
        while j!=0:
            for j in setN:
                if X[i,j].X > 0.1:
                    iroutes[r].append(j)
                    i=j
                    break
            
    Assign, VTh, Zv = Scheduling_Optimizer(nr,iroutes,rdist,problem)

    return iroutes,Assign,Zv,Zf,VTh,rdist


def k_TSP2(routes,problem):

    nr = 0
    iroutes = []
    rdist = []
    Zf = 0

    for r in range(len(routes)):    

        model = Model('TSP')
        X = model.addVars(problem.n+1,problem.n+1, vtype=GRB.BINARY, name='X')  # 1 if arc (i,j) is traversed
        y = model.addVars(problem.n+1,problem.n+1, vtype=GRB.CONTINUOUS, name='y')  # 1 if arc (i,j) is traversed
        
        setN = routes[r][0:-1]
        
        model.addConstrs(quicksum(X[i,j] for i in setN if i!=j) == 1 for j in setN)
        
        model.addConstrs(quicksum(X[i,j] for j in setN if i!=j) == 1 for i in setN)
        
        model.addConstrs(X[i,i] == 0 for i in range(problem.n+1))
        
        model.addConstrs(y[i,j] <= len(setN)*X[i,j] for i in setN for j in setN)
        
        model.addConstrs(quicksum(y[j,i]-y[i,j] for j in setN if i!=j) == 1 for i in setN if i!=0)
        
        model.setObjective(quicksum(problem.d[i][j]*X[i,j] for i in setN for j in setN if i!=j), GRB.MINIMIZE)
        
        model.setParam(GRB.Param.OutputFlag,0)
        model.optimize()
        
        nr += 1
        iroutes.append([])
        rdist.append(model.objVal)
        i=0
        j=1
        iroutes[r].append(0)
        while j!=0:
            for j in setN:
                if X[i,j].X > 0.1:
                    iroutes[r].append(j)
                    i=j
                    break
            
    return iroutes, rdist


#%%   STARTING PROCEDURE
# For each instance
for ins in instances:
    print('Instance',ins)
    print('-------------------------------------------------------------------------')

    np.random.seed(1123)
    random.seed(1123)
    
    # Problem structure
    problem = reading(ins,gnr,soltype) # reading
    # Parameters structure
    params = parameters_def(npop,problem.dv,tl,gmax,nsol,soltype)
    
    cputime = time.time()
    
    RouteSet = []
    
    g=0
    ns = params.npop
    S = Initial_Population(params)
    for i in range(params.npop):
        S[i] = decoding(problem,params,S[i],0)
        # S[i] = improve(problem,params,S[i])
        RouteSet = Decomp(S[i],RouteSet)
        if i==0:
            Best=S[0]
        if (Best.Zv > S[i].Zv) or (Best.Zv == S[i].Zv and Best.Zf > S[i].Zf):
            Best = S[i]
            # print(0,'\t','%0.02f'%Best.Zv,'\t','%0.02f'%Best.Zf,'\t','%0.02f'%(time.time()-cputime))
    
    while time.time()-cputime < params.TimeLimit and g < params.gmax and ns < params.nsol:

        g += 1
        H = []
        nh = 0

        for i in range(params.npop):
            nh += 1
            j = random.randint(0,params.npop-1)
            while j==i:
                j = random.randint(0,params.npop-1)
            
            Hc = NewSolution(i,j,S,params)
            S.append(decoding(problem,params,Hc,g))
            RouteSet = Decomp(S[-1],RouteSet)
            if (Best.Zv > S[-1].Zv) or (Best.Zv == S[-1].Zv and Best.Zf > S[-1].Zf):
                Best = S[-1]
                # print(g,'\t','%0.02f'%Best.Zv,'\t','%0.02f'%Best.Zf,'\t','%0.02f'%(time.time()-cputime))

        S = Updating(S,problem,params,g-maxg)
        # if g==100 or g==200 or g==300 or g==400 or g==500:
            # print(g,'\t','%0.02f'%Best.Zv,'\t','%0.02f'%Best.Zf,'\t','%0.02f'%(time.time()-cputime))
    
    # print('epr','\t','%0.02f'%Best.Zv)
    # print('epr','\t','%0.02f'%Best.Zf)
    # print('epr','\t',g)
    # print('epr','\t','%0.02f'%(time.time()-cputime))
    # print('-------------------------------------------------------------------------')
    Broutes, Bassign, BZv, BZf = PostOptimization(RouteSet,problem)
    # print('scp','\t','%0.02f'%BZv)
    # print('scp','\t','%0.02f'%BZf)
    # print('scp','\t','%0.02f'%(time.time()-cputime))
    # print('-------------------------------------------------------------------------')
    Broutes, Bassign, BZv, BZf, BVTh, BC = k_TSP(Broutes,problem)
    print('tsp','\t','%0.02f'%BZv)
    print('tsp','\t','%0.02f'%BZf)
    print('tsp','\t','%0.02f'%(time.time()-cputime))
    print('-------------------------------------------------------------------------')
    if min(BVTh)==0:
        Broutes, Bassign, BVTh, BZv, BZf = Selection_Scheduling2(Broutes,BC,problem)
        print('sch','\t','%0.02f'%BZv)
        print('sch','\t','%0.02f'%BZf)
        print('sch','\t','%0.02f'%(time.time()-cputime))
        print('-------------------------------------------------------------------------')

    # break

    # Covering = np.zeros((len(RouteSet),problem.n+1))
    # for r in range(len(RouteSet)):
    #     for i in range(1,len(RouteSet[r][0])-1):
    #         Covering[r][RouteSet[r][0][i]] = 1
    
    # print(len(RouteSet))
    # r1 = -1
    # while r1 < len(RouteSet)-1:
    #     r1 += 1
    #     r2 = r1
    #     while r2 < len(RouteSet)-1:
    #         r2 += 1
    #         if RouteSet[r1][4] == RouteSet[r2][4]:
    #             if sum(abs(Covering[r1]-Covering[r2]))==0:
    #                 if RouteSet[r1][1] < RouteSet[r2][1]:
    #                     # print(r1,RouteSet[r1][0])
    #                     # print(r2,RouteSet[r2][0])
    #                     RouteSet.remove(RouteSet[r2])
    #                     Covering = np.delete(Covering, r2, 0)
    #                     # Covering.remove(Covering[r2])
    #                     r2 -= 1
    #                 else:
    #                     # print(r1,RouteSet[r1][0])
    #                     # print(r2,RouteSet[r2][0])
    #                     RouteSet.remove(RouteSet[r1])
    #                     Covering = np.delete(Covering, r1, 0)
    #                     # Covering.remove(Covering[r1])
    #                     r1 -= 1
    #                     r2 = len(RouteSet)+1
    # print(len(RouteSet))
    # print('pro','\t',time.time()-cputime)
    
    # nsol = 5
    # Broutes, Bassign, BVTh, BZv, BZf = PostOptimization2(RouteSet,problem,nsol)
    # print('pos','\t',BZv)
    # print('pos','\t',BZf)
    # print('pos','\t',time.time()-cputime)
    # print('-------------------------------------------------------------------------')
