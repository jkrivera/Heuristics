
import numpy as np
import time
import random
import matplotlib.pyplot as plt

from destroy import Drand
from repair import Rgreedy
from repair import Rexact
from validate import validate


def lns(N,M,P,c,a,b,F,cputime):

    sol = []
    it = 0
    while (time.time()-cputime) <= 60*5:
        it=it+1
        
        Fp = Drand(N,M,P,c,a,b,F)
#        validate(N,M,P,c,a,b,F,ns)
        
        selr = random.random()
        if selr < 0:
            F = Rgreedy(N,M,P,c,a,b,Fp,F,cputime)
        else:
            F = Rexact(N,M,P,c,a,b,Fp,F,cputime)
#        validate(N,M,P,c,a,b,F,ns)
        
#        print(it,nsnew,time.time()-cputime)
#        F,ns=dominance(P,F,ns,nsnew)
        sol.append(F.Z[0])
#        if selr <= 0.5:
#            print(it,1,time.time()-cputime)
#        else:
#            print(it,2,time.time()-cputime)
    
    plt.plot(sol)
    plt.ylabel('Objective function')
    plt.xlabel('Iterations')
    plt.show()
    print(it)

    return F