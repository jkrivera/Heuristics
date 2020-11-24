import numpy as np
import time
import matplotlib.pyplot as plt


from vnd import vnd
from perturbation import perturbation


def ils(N,M,P,c,a,b,F,cputime,cp):

    sol = []
    sol.append(F.Z[0]-10000*F.Z[1])
    print(F.Z)
    F = vnd(N,M,P,c,a,b,F,cputime,sol,cp)
    print(F.Z)
    itils = 0
    while (time.time()-cputime) <= 60*cp:
        itils=itils+1
    
        Fp = perturbation(N,M,P,c,a,b,F)
        sol.append(F.Z[0]-10000*F.Z[1])
        
        Fa = vnd(N,M,P,c,a,b,Fp,cputime,sol,cp)

        plt.plot(sol)
        plt.ylabel('Objective function')
        plt.xlabel('Iterations')
        plt.show()

        if Fa.Z[P] < F.Z[P]:
            F = Fa.copy()
            print(F.Z)
        else:
            if Fa.Z[P] == F.Z[P] and Fa.Z[0] > F.Z[0]:
                F = Fa.copy()
                print(F.Z)
    
    print(itils)

    return F