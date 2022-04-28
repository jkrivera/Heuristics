import numpy as np

def GRH(problem,param):
    
    P = np.random.random((param.npop,problem.n))
    
    return P