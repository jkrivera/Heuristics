function [P,f,niter] = DE(n,d,npop,tmax,pmutDE,F)

tic

[P,f] = InitialPopulationRK(n,d,npop);

niter=0;
while toc < tmax
    niter=niter+1;
    for j = 1:npop
        a = randi(npop);
        while a==j
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
        r = randi(n);
        v=zeros(1,n);
        for k = 1:n
            if rand < pmutDE || k==r
                v(k)=P(c,k)+F*(P(a,k)-P(b,k));
            else
                v(k)=P(j,k);
            end
        end
        vf=FO_RK(v,npop,n,d);
        if vf<f(j)
            f(j)=vf;
            P(j,:)=v;
        end
    end
end

end