# -*- coding: utf-8 -*-
"""
Created on Mon Oct 26 17:39:08 2020

@author: jrivera6
"""

import numpy as np
import math

def construction(n, m, c, a, ni, nj, listi, listj):
    
    Z = 0
    na = 0
    
    assigned = np.zeros((n))
    covered = np.zeros((m))
    S = np.zeros((n))
    
    sel = -1
    nui = np.zeros((n))
    for i in range(n):
        nui[i] = ni[i]
        if sel == -1 or nui[i]>nui[sel]:
            sel = i
    
    while sel != -1:
        assigned[sel] = 1
        Z = Z + c[sel]
        na = na + 1
        
        for j in range(int(ni[sel])):
            if covered[int(listi[sel][j])] == 0:
                covered[int(listi[sel][j])] = 1
                for k in range(int(nj[int(listi[sel][j])])):
                    nui[int(listj[int(listi[sel][j])][k])] = nui[int(listj[int(listi[sel][j])][k])] - 1
        
        sel = -1
        for i in range(n):
            if (sel == -1 and nui[i]>0) or (nui[i]>nui[sel] and nui[i]>0):
                sel = i
                
    h = 0
    for i in range(n):
        if assigned[i] == 1:
            S[h] = i
            h=h+1
    
    return S, assigned, covered, Z, na


def construction_red(n, m, c, a, ni, nj, listi, listj, K, w):
    
    Z = 0
    na = 0
    
    assigned = np.zeros((n))
    covered = np.zeros((m))
    S = np.zeros((K))
    
    sel = -1
    nui = np.zeros((n))
    for i in range(n):
        nui[i] = ni[i]
        if sel == -1 or nui[i]>nui[sel]:
            sel = i
    
    while sel != -1:
        assigned[sel] = 1
        na = na + 1
        
        for j in range(int(ni[sel])):
            covered[int(listi[sel][j])] = covered[int(listi[sel][j])] + 1
            if covered[int(listi[sel][j])] == 1:
                for k in range(int(nj[int(listi[sel][j])])):
                    nui[int(listj[int(listi[sel][j])][k])] = nui[int(listj[int(listi[sel][j])][k])] - 1
        
        sel = -1
        for i in range(n):
            if (sel == -1 and nui[i]>0) or (nui[i]>nui[sel] and nui[i]>0):
                sel = i
    
    while na < K:
        sel = -1
        for i in range(n):
            if (sel == -1 and assigned[i]==0) or (ni[i]>ni[sel] and assigned[i]==0):
                sel = i

        assigned[sel] = 1
        na = na + 1
        
        for j in range(int(ni[sel])):
            covered[int(listi[sel][j])] = covered[int(listi[sel][j])] + 1
                        
    h = 0
    for i in range(n):
        if assigned[i] == 1:
            S[h] = i
            h=h+1
    
    for j in range(m):
        Z = Z + w[j]*covered[j]
    
    return S, assigned, covered, Z, na