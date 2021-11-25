function [sol,f] = LS_2(n,d,sol,f,pos,Ms)

fb=Inf;
solb=sol;
fin=0;

while fin==0
    fin=1;
    for i = 2:n-1
        for j = 2:0.6*n
            h=Ms(sol(i-1),j);
            if pos(h)>i && pos(h)<=n
                vec=sol;
                for k=i:pos(h)
                    vec(k)=sol(pos(h)+i-k);
                end
%                 fv=0;
%                 for k=1:n
%                     fv=fv+d(vec(k),vec(k+1));
%                 end
                fv=f-d(sol(i-1),sol(i))-d(sol(pos(h)),sol(pos(h)+1))+d(sol(i-1),sol(pos(h)))+d(sol(i),sol(pos(h)+1));
                if fb>fv
                    fb=fv;
                    solb=vec;
                end
            end
        end
    end
    if f>fb+0.001
        f=fb;
        sol=solb;
        fin=0;
    end
end

end