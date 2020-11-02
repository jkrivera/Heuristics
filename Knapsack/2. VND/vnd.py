# -*- coding: utf-8 -*-
"""
Created on Fri Oct 30 17:58:10 2020

@author: jrivera6
"""
import numpy as np
import time

from neighborhoods import N1
from neighborhoods import N2
from neighborhoods import N3
from neighborhoods import N4
from neighborhoods import N5
from neighborhoods import N6
from pareto_dominance import dominance
from validate import validate


def vnd(N,M,P,c,a,b,F,cputime):

    k=1
    it=1
    while k<=6:
        
        if k==1:
            print("")
            it = it+1
            # Add an item
            F,k=N1(N,M,P,c,a,b,F,k+1)
#            validate(N,M,P,c,a,b,F)
            print(it, 1, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break

        if k==2:
            # Remove one item
            F,k=N2(N,M,P,c,a,b,F,k+1)
#            validate(N,M,P,c,a,b,F)
            print(it, 2, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break

        if k==3:
            # Change one item (remove and insert)
            F,k=N3(N,M,P,c,a,b,F,k+1)
#            validate(N,M,P,c,a,b,F)
            print(it, 3, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break
           
        if k==6:
            # Change two items (remove 2 and insert 2)
            F,k=N4(N,M,P,c,a,b,F,k+1,cputime)
#            validate(N,M,P,c,a,b,F)
            print(it, 6, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break
            
        if k==4:
            # Remove 1 item and insert 2
            F,k=N5(N,M,P,c,a,b,F,k+1,cputime)
#            validate(N,M,P,c,a,b,F)
            print(it, 4, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break
            
        if k==5:
            # Remove 1 item and insert 2
            F,k=N6(N,M,P,c,a,b,F,k+1,cputime)
#            validate(N,M,P,c,a,b,F)
            print(it, 5, k, F.Z, (time.time()-cputime))
#                if (time.time()-cputime) > 5*60:
#                    break

#        if (time.time()-cputime) > 5*60:
#            break

    return F