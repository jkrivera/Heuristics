# -*- coding: utf-8 -*-
"""
Created on Mon Oct 26 14:16:39 2020

@author: jrivera6
"""

# -*- coding: utf-8 -*-

from xlrd import open_workbook
import numpy as np
import time
import random


from reading import reading
from construction import construction
from construction import construction_red

ins = 'scpe5'
#ins = 'scpnrh5'

n, m, c, a, ni, nj, listi, listj, K, w = reading(ins)

S, assigned, covered, Z, na = construction(n, m, c, a, ni, nj, listi, listj)

S, assigned, covered, Z, na = construction_red(n, m, c, a, ni, nj, listi, listj, K, w)