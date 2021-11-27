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


def vnd(N,M,P,c,a,b,F,ns,cputime):

    s=1
    while s <= ns:
        k=1
        while k<=1:
            if k==6:
                # Add an item
                F,k,nsnew=N1(N,M,P,c,a,b,F,s,ns,k+1)
#                print(1, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                print(1, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break

            if k==5:
                # Remove one item
                F,k,nsnew=N2(N,M,P,c,a,b,F,s,ns,k+1)
#                print(2, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                print(2, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break

            if k==4:
                # Change one item (remove and insert)
                F,k,nsnew=N3(N,M,P,c,a,b,F,s,ns,k+1)
#                print(3, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                print(3, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break
               
            if k==1:
                # Change two items (remove 2 and insert 2)
                F,k,nsnew=N4(N,M,P,c,a,b,F,s,ns,k+1,cputime)
#                print(6, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                F,ns,s,k=dominance_s(P,F,ns,nsnew,s,k)
#                print(6, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break
                
            if k==4:
                # Remove 1 item and insert 2
                F,k,nsnew=N5(N,M,P,c,a,b,F,s,ns,k+1,cputime)
#                print(4, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                F,ns,s,k=dominance_s(P,F,ns,nsnew,s,k)
#                print(4, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break
                
            if k==5:
                # Remove 2 item and insert 1
                F,k,nsnew=N6(N,M,P,c,a,b,F,s,ns,k+1,cputime)
#                print(5, nsnew-ns, (time.time()-cputime))
#                validate(N,M,P,c,a,b,F,nsnew)
                F,ns,s,k=dominance(P,F,ns,nsnew,s,k)
#                F,ns,s,k=dominance_s(P,F,ns,nsnew,s,k)
#                print(5, s, ns, (time.time()-cputime))
                if (time.time()-cputime) > 5*60:
                    break

            if (time.time()-cputime) > 5*60:
                break
        s = s+1
        if (time.time()-cputime) > 5*60:
            break

    return F, ns