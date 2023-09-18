function [P,f,niter] = GARK(n,d,npop,tmax,nc,pmut,nrnd)

tic

[P,f] = InitialPopulationRK(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    
    for h = 1:2:nc

        [x,y] = Tournament(npop,f);
        
        [h1,h2] = CrossoverRK(P,npop,n,x,y);
        
        if rand < pmut
            h1 = MutationRK2(h1,n,d);
        end
        if rand < pmut
            h2 = MutationRK2(h2,n,d);
        end
        
        f1 = distanceRK(h1,npop,n,d);
        f2 = distanceRK(h2,npop,n,d);
        P = [P;h1;h2];
        f = [f f1 f2];
    end
    
%     [P,f] = update_diff(P,f,npop,n);
    [P,f] = update_diff_weighted(P,f,npop,n);
    
%     [f,fs] = sort(f);
%     f(npop+1-nrnd:end)=[];
%     P=P(fs(1:npop-nrnd),:);
%     
%     [New,fnew] = InitialPopulationRK(n,d,nrnd);
%     P = [P;New];
%     f = [f fnew];
    
    [min(f) niter toc]
end

end