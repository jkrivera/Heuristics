function [sol, f] = Perturbation(n,d,sol,f)

for k = 1:5
    r = randi(n,1,1);
    while r==1 || r==n+1
        r = randi(n,1,1);
    end
    p = randi(n,1,1);
    while p==1 || p==n+1 || p==r
        p = randi(n,1,1);
    end
    
    aux=sol(r);
    sol(r)=[];
    sol = [sol(1:p-1) aux sol(p:end)];
end

f=0;
for i = 1:n
    f=f+d(sol(i),sol(i+1));
end

end