import numpy as np
import time
import random

from destroy import Drand
from repair import Rgreedy
from repair import Rexact
from pareto_dominance import dominance
from validate import validate


def lns(N,M,P,c,a,b,UB,LB,F,ns,cputime):

    it=0
    while (time.time()-cputime) <= 5*60:
        it=it+1
        
        sel = random.randint(0,ns-1)
        
        Fp = Drand(N,M,P,c,a,b,F[sel])
        
        selr = random.randint(1,1)
        if selr == 1:
            F, nsnew = Rgreedy(N,M,P,c,a,b,UB,LB,[Fp],F,ns,cputime)
        else:
            F, nsnew = Rexact(N,M,P,c,a,b,UB,LB,[Fp],F,ns,cputime)
        
        F,ns,s,k=dominance(P,F,ns,nsnew,s,k)

    return F, ns