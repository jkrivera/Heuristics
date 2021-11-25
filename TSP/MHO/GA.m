function [P,f,niter] = GA(n,d,npop,tmax,nc,pmut)

tic

[P,f] = InitialPopulation(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    for h = 1:2:nc

        [x,y] = Tournament(npop,f);
        
        [h1,h2] = Crossover(P,npop,n,x,y);
        
        if rand < pmut
            h1 = Mutation(h1,n);
        end
        if rand < pmut
            h2 = Mutation(h2,n);
        end
        
        f(npop+h) = 0;
        f(npop+h+1) = 0;
        for i = 1:n
            f(npop+h) = f(npop+h) + d(h1(i),h1(i+1));
            f(npop+h+1) = f(npop+h+1) + d(h2(i),h2(i+1));
        end
        P = [P;h1;h2];
    end
    [f,fs] = sort(f);
    f(npop+1:end)=[];
    P=P(fs(1:npop),:);
end

end