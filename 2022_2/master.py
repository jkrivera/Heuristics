import math
import numpy as np
import openpyxl
import os
import random
import time


##############################################################################
############################### DATA CLASS ###################################
##############################################################################
class Problem:
  def __init__(self, n, Q, q, d, sd):
    self.n = n         # number of nodes
    self.Q = Q         # Vehicle capacity
    self.q = q         # demand
    self.d = d         # distances
    self.sd = sd       # sorted distances
##############################################################################
################################# READING ####################################
##############################################################################
def reading_names():
    with open('Instances/instances.txt') as f:
        lines = f.readlines()
    ninst = len(lines)
    for i in range(ninst):
        lines[i] = lines[i].replace("\n","")
    return lines, ninst


def reading(files):
    with open('Instances/PDTSP/' + files) as f:
        lines = f.readlines()
    
    n = len(lines)
    Q = 10
    pts = np.zeros((n+1,2))
    q = np.zeros(n+1)
    
    line = lines[0].split(',')
    pts[0][0] = line[1]
    pts[0][1] = line[2]
    q[0] = line[3]
    q[n] = line[4]
    
    for i in range(1,n):
        line = lines[i].split(',')
        pts[i][0] = line[1]
        pts[i][1] = line[2]
        q[i] = line[3]
    
    d=np.zeros((n+1,n+1))
    for i in range(n+1):
        d[i][i] = math.inf
        for j in range(i+1,n+1):
            d[i][j] = math.ceil(math.sqrt((pts[i][0] - pts[j][0])**2 + ((pts[i][1] - pts[j][1])**2)))
            d[j][i] = d[i][j]
    
    sd=[]
    for i in range(n):
        sd.append(np.argsort(d[i][:]))
        
    problem = Problem(n,Q,q,d,sd)
    
    return problem
##############################################################################
####################### GREEDY RANDOMIZED HEURISTIC ##########################
##############################################################################
def GRH(problem,K,nsol):
    
    np.random.seed(1123)
    
    Zb = math.inf
    Fb = math.inf

    for sl in range(nsol):
        S = np.zeros(problem.n+1)
        S[0] = 0
        load = -problem.q[0]
        Z = 0
        F = 0
        Fc = 0
        check = np.zeros(problem.n+1)
        check[0] = 1
        check[problem.n] = 1
        for i in range(1,problem.n):
            RCLd = np.zeros(K)
            RCLp = np.zeros(K)
            nRCLd = 0
            nRCLp = 0
            
            for j in range(problem.n):
                if check[problem.sd[int(S[i-1])][j]]==0:
                    if problem.q[problem.sd[int(S[i-1])][j]]>0:
                        if nRCLd<K:
                            if load - problem.q[problem.sd[int(S[i-1])][j]] >= 0:
                                RCLd[nRCLd] = problem.sd[int(S[i-1])][j]
                                nRCLd += 1
                    else:
                        if nRCLp<K:
                            if load - problem.q[problem.sd[int(S[i-1])][j]] <= problem.Q:
                                RCLp[nRCLp] = problem.sd[int(S[i-1])][j]
                                nRCLp += 1
                    if nRCLd + nRCLp == 2*K:
                        break
            while nRCLd + nRCLp == 0:
                F += 1
                if F > Fb:
                    break
                if F < Fb:
                    for j in range(problem.n):
                        if check[problem.sd[int(S[i-1])][j]]==0:
                            if problem.q[problem.sd[int(S[i-1])][j]]>0:
                                if nRCLd<K:
                                    if load - problem.q[problem.sd[int(S[i-1])][j]] >= 0:
                                        RCLd[nRCLd] = problem.sd[int(S[i-1])][j]
                                        nRCLd += 1
                            else:
                                if nRCLp<K:
                                    if load - problem.q[problem.sd[int(S[i-1])][j]] <= problem.Q+F:
                                        RCLp[nRCLp] = problem.sd[int(S[i-1])][j]
                                        nRCLp += 1
                            if nRCLd + nRCLp == 2*K:
                                break
            if Fc < F:
                Fc=F
            if F > Fb:
                break
            sel = np.random.randint(nRCLd + nRCLp)
            RCL = np.concatenate((RCLd[0:nRCLd],RCLp[0:nRCLp]))
            sel = RCL[sel]
            check[int(sel)]=1
            S[i] = sel
            load -= problem.q[int(sel)]
            Z += problem.d[int(S[i-1])][int(S[i])]
            if Z > Zb:
                break
            if Fc < F:
                Fc=F
            F = 0
            
        S[i+1] = problem.n
        Z += problem.d[int(S[i])][int(S[i+1])]
        
        if Fc < Fb or (Fc == Fb and Z <= Zb):
            Zb=Z
            Sb=S
            Fb=Fc
    
    return Sb,Zb,Fb
##############################################################################
################################## START #####################################
##############################################################################
[files, ninst] = reading_names()

tl   = 60*10 # Time Limit
niter = 1000  # maximum number of generations
##############################################################################
inst = 0
while inst < ninst:
    problem = reading(files[inst])

    K=2
    cputime = time.time()
    S,Z,F = GRH(problem,K,niter)

    print(inst,problem.n,"\t",Z,"\t",F,"\t",(time.time()-cputime))
    inst+=1


##############################################################################
# For each instance

        
# wb = openpyxl.Workbook()
# hoja = wb.active
# for i in answer:
#     # producto es una tupla con los valores de un producto 
#     hoja.append(i)
# wb.save('constructivo10.xlsx')
# print(answer)