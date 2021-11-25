function [X,f,niter] = PSO(n,d,npop,tmax,c1,c2,w)

tic

[X,f] = InitialPopulationRK(n,d,npop);

V = zeros(npop,n);
B=X;

[~, lider] = min(f);
min(f)
niter=0;
while toc < tmax
    V = w*(V + c1*rand*(B-X) + c2*rand*(X(lider)-X));
    Y = X+V;
    
    lider=1;
    for i = 1:npop
        f1 = distanceRK(Y(i,:),npop,n,d);
        if f1<f(i)
            B(i,:)=Y(i,:);
        end
        if f1<f(lider)
            lider=i;
        end
        f(i)=f1;
    end
    X=Y;
end
min(f)
end