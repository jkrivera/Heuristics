function [P,f,niter] = GARK(n,d,npop,tmax,nc,pmut)

tic

[P,f] = InitialPopulationRK(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    
    for h = 1:2:nc

        [x,y] = Tournament(npop,f);
        
        [h1,h2] = CrossoverRK(P,npop,n,x,y);
        
        if rand < pmut
            h1 = MutationRK(h1,n);
        end
        if rand < pmut
            h2 = MutationRK(h2,n);
        end
        
        f1 = distanceRK(h1,npop,n,d);
        f2 = distanceRK(h2,npop,n,d);
        P = [P;h1;h2];
        f = [f f1 f2];
    end
    [f,fs] = sort(f);
    f(npop+1:end)=[];
    P=P(fs(1:npop),:);
%     [min(f) max(f)]
end

end