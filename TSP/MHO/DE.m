function [P,f,niter] = DE(n,d,npop,tmax,pmutde,F)

tic

[P,f] = InitialPopulationRK(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    for j = 1:npop
        a = randi(npop);
        while a == j
            a = randi(npop);
        end
        b = randi(npop);
        while b==j || b==a
            b = randi(npop);
        end
        c = randi(npop);
        while c==j || c==a || c==b
            c = randi(npop);
        end
        r=randi(n-1)+1;
        
        v=P(j,:);
        for k = 1:n
            if rand < pmutde || k==r
                v(k)=P(c,k)+F*(P(a,k)-P(b,k));
            end
        end
        f1 = distanceRK(v,npop,n,d);
        if f1<f(j)
            f(j)=f1;
            P(j,:)=v;
        end
    end
end

end