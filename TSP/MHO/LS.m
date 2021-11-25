function [sol,f] = LS(n,d,sol,f)

fb=Inf;
solb=sol;
fin=0;

while fin==0
    fin=1;
    for i = 2:n-1
        for j = i+1:n
            vec=sol;
            for k=i:j
                vec(k)=sol(j+i-k);
            end
%             fv=0;
%             for k=1:n
%                 fv=fv+d(vec(k),vec(k+1));
%             end
            fv=f-d(sol(i-1),sol(i))-d(sol(j),sol(j+1))+d(sol(i-1),sol(j))+d(sol(i),sol(j+1));
            if fb>fv
                fb=fv;
                solb=vec;
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