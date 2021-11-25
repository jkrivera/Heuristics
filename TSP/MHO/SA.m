function [best,fb]=SA(n,d,sol,f,Ti,Tf,L,r,tmax)

best=sol;
fb = f;

while toc <= tmax
	T=Ti;
    while T>Tf
        for l=1:L
            [vec,fv] = RndNeighbor(n,d,sol,f);
            if fv-f < 0
                sol=vec;
                f=fv;
                if f<fb
                    fb=f;
                    best=sol;
                end
            else
                if rand <= exp((f-fv)/T)
                    sol=vec;
                    f=fv;
                end
            end
        end
        T=r*T;
    end
end

end