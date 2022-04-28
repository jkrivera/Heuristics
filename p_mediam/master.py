import numpy as np
import math
import time
import os
import openpyxl

from solution_class import Solution
from reading import reading
from construction import construction1
from construction import construction2
from construction import construction3

# For each instance
# i=5
# for ins in range(i,i+1):
for ins in range(10,16):
    
    print("Instance ",str(ins))
    
    start = time.time()
    
    n, p, Q, q, d = reading(ins)
    print(n,p,Q,sum(q),sum(q)/Q/p)
    print("")
    
    cputime = time.time()
    Sol1=construction1(n,p,Q,q,d)
    print((time.time()-cputime))
    print("")
    
    # cputime = time.time()
    # Sol2=construction2(n,p,Q,q,d,0.9)
    # print((time.time()-cputime))
    # print("")
    
    cputime = time.time()
    Sol3=construction3(n,p,Q,q,d,0.95)
    print((time.time()-cputime))
    print("")

    cputime = time.time()
    Sol3=construction3(n,p,Q,q,d,0.9)
    print((time.time()-cputime))
    print("")

    cputime = time.time()
    Sol3=construction3(n,p,Q,q,d,0.8)
    print((time.time()-cputime))
    print("")

    cputime = time.time()
    Sol3=construction3(n,p,Q,q,d,0.6)
    print((time.time()-cputime))
    print("")

# wb = openpyxl.Workbook()
# hoja = wb.active
# for i in answer:
#     # producto es una tupla con los valores de un producto 
#     hoja.append(i)
# wb.save('constructivo10.xlsx')
# print(answer)