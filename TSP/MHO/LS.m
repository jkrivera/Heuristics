function [sol,f] = LS(n,d,sol,f)

fb=Inf;
solb=sol;
fin=0;

itmax = Inf;
it=0;
% tic

while fin==0 && it<itmax
    it=it+1;
    fin=1;
    for i = 2:n-1
        for j = i+1:n
            if d(sol(i-1),sol(i))+d(sol(j),sol(j+1)) > d(sol(i-1),sol(j))+d(sol(i),sol(j+1))
                %             fv=0;
                %             for k=1:n
                %                 fv=fv+d(vec(k),vec(k+1));
                %             end
                fv=f-d(sol(i-1),sol(i))-d(sol(j),sol(j+1))+d(sol(i-1),sol(j))+d(sol(i),sol(j+1));
                if fb>fv
                    vec=sol;
                    for k=i:j
                        vec(k)=sol(j+i-k);
                    end
                    
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
%     [it, f, toc]
end

end