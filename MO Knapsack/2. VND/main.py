# -*- coding: utf-8 -*-

from xlrd import open_workbook
import xlsxwriter
import numpy as np
import time
import random


from solution_class import Solution
from reading import reading
from construction import construction
from vnd import vnd


for ins in range(1,21):

    workbook = xlsxwriter.Workbook('JKRvnd' + str(ins) + '.xlsx')
    
    N, M, P, c, a, b = reading(ins)
    
    cputime = time.time()
    
    # Initial solution
    F, ns = construction(N,M,P,c,a,b)

    # Improvement
    F, ns = vnd(N,M,P,c,a,b,F,ns,cputime)

    name = 'I' + str(ins)
    print(name)
    worksheet = workbook.add_worksheet(name)
    worksheet.write(0, 0, ns)
    print(ns)
    for i in range(ns):
        for j in range(int(F[i].Xs[0])+1):
            if j>0:
                worksheet.write(i+1, j, F[i].Xs[j]+1)
            else:
                worksheet.write(i+1, j, F[i].Xs[j])
        for j in range(M):
            worksheet.write(i+1, int(F[i].Xs[0])+1 + j, F[i].R[j])
        for j in range(P):
            worksheet.write(i+1, int(F[i].Xs[0])+1 + M + j, F[i].Z[j])

    print("%1.2f \t" % (time.time()-cputime))
    print("")
    
    workbook.close()