# -*- coding: utf-8 -*-

from xlrd import open_workbook
import numpy as np
import time
import random


from solution_class import Solution
from reading import reading
from construction import construction
from lns import lns


for ins in range(14,15):
    N, M, P, c, a, b = reading(ins)
    
    cputime = time.time()
    
    # Initial solution
    F = construction(N,M,P,c,a,b)

    # Improvement
    F = lns(N,M,P,c,a,b,F,cputime)

    print(F.Z)
    print("%1.2f \t" % (time.time()-cputime))