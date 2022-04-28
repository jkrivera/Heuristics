import numpy as np
import math
import time
import os
import openpyxl

from Solution_pmedcap import Solution_pmedcap
from pmedcap_class import Problem
from pmedcap_class import prob_precomputing
from BRKGA_class import parameters_def
from reading_pmedcap import reading_pmedcap
from GRH_pmedcap import GRH

# For each instance
i=1
for ins in range(i,i+1):
# for ins in range(1,16):
    
    print("Instance ",str(ins))
    
    problem = reading_pmedcap(ins)
    param = parameters_def(100)
    precomp = prob_precomputing(problem)
    print(problem.n,problem.p,problem.Q,sum(problem.q),sum(problem.q)/problem.Q/problem.p)
    print("")
    
    cputime = time.time()
    P = GRH(problem,param) # Greedy Randomized Heuristic
    print((time.time()-cputime))
    print("")
    
# wb = openpyxl.Workbook()
# hoja = wb.active
# for i in answer:
#     # producto es una tupla con los valores de un producto 
#     hoja.append(i)
# wb.save('constructivo10.xlsx')
# print(answer)