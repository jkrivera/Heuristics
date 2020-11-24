import numpy as np


def dominance(P,F,ns,nsnew):
    i=0
    while i<nsnew:
        j=max(i+1,ns)
        while j<nsnew:
            
            rem=-1
            if F[i].Z[P]<F[j].Z[P]:
                F.remove(F[j])
                rem = j
            else:
                if F[i].Z[P]>F[j].Z[P]:
                    F.remove(F[i])
                    rem = i
                else:
                    di=0
                    dj=0
                    de=0
                    for p in range(P):
                        if F[i].Z[p] > F[j].Z[p]:
                            di = di+1
                        if F[i].Z[p] < F[j].Z[p]:
                            dj = dj+1
                        if F[i].Z[p] == F[j].Z[p]:
                            de = de+1
                    if di==0 and de!=P:
                        F.remove(F[i])
                        rem = i
                    if dj==0 and de!=P:
                        F.remove(F[j])
                        rem = j
                    if de==P:
                        F.remove(F[j])
                        rem = j

            if rem == i:
                j=nsnew
                if i<ns:
                    ns=ns-1
                nsnew=nsnew-1
                i=i-1
            if rem == j:
                nsnew=nsnew-1
                j=j-1
            j=j+1
        i=i+1
    
    ns = nsnew
    
    return F, ns