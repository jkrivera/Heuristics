
import numpy as np
import time
import random

from destroy import Drand
from destroy import Drand2
from repair import Rgreedy
from repair import Rexact
from repair import Rexact2
from pareto_dominance import dominance
from validate import validate


def lns(N,M,P,c,a,b,UB,LB,F,ns,cputime):

    it=0
    while (time.time()-cputime) <= 5*60:
        it=it+1
        
        sel = random.randint(0,ns-1)
        selr = random.random()
        
        if selr <=0.5:
            Fp = Drand(N,M,P,c,a,b,F,sel)
        if selr >0.5:
            Fp = Drand2(N,M,P,c,a,b,F,sel)
#        validate(N,M,P,c,a,b,F,ns)
        
        if selr < 0:
            F, nsnew = Rgreedy(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime)
        if selr <=0.5:
            F, nsnew = Rexact(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime)
        if selr >0.5:
            F, nsnew = Rexact2(N,M,P,c,a,b,UB,LB,Fp,F,ns,cputime)
#        validate(N,M,P,c,a,b,F,ns)
        
#        print(it,nsnew,time.time()-cputime)
        F,ns=dominance(P,F,ns,nsnew)
#        if selr <= 0.5:
#            print(it,ns,1,time.time()-cputime)
#        else:
#            print(it,ns,2,time.time()-cputime)

    return F, ns