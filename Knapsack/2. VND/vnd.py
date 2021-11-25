# -*- coding: utf-8 -*-
"""
Created on Fri Oct 30 17:58:10 2020

@author: jrivera6
"""
import numpy as np
import time
import matplotlib.pyplot as plt


from neighborhoods import N1
from neighborhoods import N2
from neighborhoods import N3
from neighborhoods import N4
from neighborhoods import N5
from neighborhoods import N6
from pareto_dominance import dominance
from validate import validate


def vnd(N,M,P,c,a,b,F,cputime,sol,cp):

#    sol = []
    ex = np.zeros((6))
    fr = np.zeros((6))
    k=1
    it=1
    while k<=6:
        
        if k==1:
#            print("")
            it = it+1
            # Add an item
            F,k=N1(N,M,P,c,a,b,F,k+1)
            fr[0]=fr[0]+1
            if k==1:
                ex[0]=ex[0]+1
            validate(N,M,P,c,a,b,F)
            sol.append(F.Z[0]-10000*F.Z[1])
            if (time.time()-cputime) > cp*60:
                break

        else:
            if k==2:
                # Remove one item
                F,k=N2(N,M,P,c,a,b,F,k+1)
                fr[1]=fr[1]+1
                if k==1:
                    ex[1]=ex[1]+1
                validate(N,M,P,c,a,b,F)
                sol.append(F.Z[0]-10000*F.Z[1])
                if (time.time()-cputime) > cp*60:
                    break
    
            else:
                if k==3:
                    # Change one item (remove and insert)
                    F,k=N3(N,M,P,c,a,b,F,k+1)
                    validate(N,M,P,c,a,b,F)
                    fr[2]=fr[2]+1
                    if k==1:
                        ex[2]=ex[2]+1
                    sol.append(F.Z[0]-10000*F.Z[1])
                    if (time.time()-cputime) > cp*60:
                        break
                   
                else:
                    if k==6:
                        # Change two items (remove 2 and insert 2)
                        F,k=N4(N,M,P,c,a,b,F,k+1,cputime,cp)
                        validate(N,M,P,c,a,b,F)
                        fr[5]=fr[5]+1
                        if k==1:
                            ex[5]=ex[5]+1
                        sol.append(F.Z[0]-10000*F.Z[1])
                        if (time.time()-cputime) > cp*60:
                            break
                        
                    else:
                        if k==4:
                            # Remove 1 item and insert 2
                            F,k=N5(N,M,P,c,a,b,F,k+1,cputime)
                            validate(N,M,P,c,a,b,F)
                            fr[3]=fr[3]+1
                            if k==1:
                                ex[3]=ex[3]+1
                            sol.append(F.Z[0]-10000*F.Z[1])
                            if (time.time()-cputime) > cp*60:
                                break
                            
                        else:
                            if k==5:
                                # Remove 2 item and insert 1
                                F,k=N6(N,M,P,c,a,b,F,k+1,cputime)
                                fr[4]=fr[4]+1
                                if k==1:
                                    ex[4]=ex[4]+1
                                validate(N,M,P,c,a,b,F)
                                sol.append(F.Z[0]-10000*F.Z[1])
                                if (time.time()-cputime) > cp*60:
                                    break

        if (time.time()-cputime) > cp*60:
            break
    
#    plt.plot(sol)
#    plt.ylabel('Objective function')
#    plt.xlabel('Iterations')
#    plt.show()
#    print(it)
#    
#    p = np.zeros((6))
#    for i in range(6):
#        p[i]=ex[i]/fr[i]
#    print(p)

    return F