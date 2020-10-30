# -*- coding: utf-8 -*-
"""
Created on Fri Oct 30 17:58:10 2020

@author: jrivera6
"""
import numpy as np

from neighborhoods import N1
from neighborhoods import N2
from neighborhoods import N3
from neighborhoods import N4
from neighborhoods import N5


def vnd(N,M,P,c,a,b,X,Xs,Xn,Z,R):

    k=1
    while k<=1:
        if k==1:
            X,Xs,Xn,Z,R,k=N1(N,M,P,c,a,b,X,Xs,Xn,Z,R,k+1)
        if k==2:
            X,Xs,Xn,Z,R,k=N2(N,M,P,c,a,b,X,Xs,Xn,Z,R,k+1)
        if k==3:
            X,Xs,Xn,Z,R,k=N3(N,M,P,c,a,b,X,Xs,Xn,Z,R,k+1)
        if k==4:
            X,Xs,Xn,Z,R,k=N4(N,M,P,c,a,b,X,Xs,Xn,Z,R,k+1)
        if k==5:
            X,Xs,Xn,Z,R,k=N5(N,M,P,c,a,b,X,Xs,Xn,Z,R,k+1)

    return X, Xs, Xn, Z, R