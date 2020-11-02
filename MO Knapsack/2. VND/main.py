# -*- coding: utf-8 -*-

from xlrd import open_workbook
import numpy as np
import time
import random


from solution_class import Solution
from reading import reading
from construction import construction
from vnd import vnd


for ins in range(1,2):
    N, M, P, c, a, b = reading(ins)
    
    cputime = time.time()
    
    # Initial solution
    F, ns = construction(N,M,P,c,a,b)

    # Improvement
    F, ns = vnd(N,M,P,c,a,b,F,ns,cputime)

    print(ns)
    print("%1.2f \t" % (time.time()-cputime))