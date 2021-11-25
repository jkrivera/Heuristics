function [sol,f] = FastLS2(n,d,sol,f)

fb=Inf;
solb=sol;
fin=0;

while fin==0
    fin=1;
    nsol=0;
    for h = 1:0.3*(n-1)*(n-2)/2
        i = randi(n-3)+1;
        j = randi(n-i-1)+i+1;
        nsol=nsol+1;
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
    if f>fb+0.001
        f=fb;
        sol=solb;
        fin=0;
    end
end

end