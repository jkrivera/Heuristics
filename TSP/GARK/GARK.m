function [P,f,niter] = GARK(n,d,npop,tmax,nc,pmut)

tic

[P,f] = InitialPopulationRK(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    for c = 1:2:nc
        [p1,p2]=Tournament(npop,f);
        [h1,h2]=CrossoverRK(P,p1,p2,n);
        if rand < pmut
            h1 = mutationRK(h1,n);
        end
        if rand < pmut
            h2 = mutationRK(h2,n);
        end
        P(npop+c,:)=h1;
        f(npop+c)=FO_RK(h1,npop,n,d);
        P(npop+c+1,:)=h2;
        f(npop+c+1)=FO_RK(h2,npop,n,d);
    end
    [~,ord] = sort(f);
    P=P(ord(1:npop),:);
    f=f(ord(1:npop));

end

end