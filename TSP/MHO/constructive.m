function [sol,f]=constructive(n,d)

sol=zeros(1,n+1);
check=zeros(1,n);

sol(1) = randi(n,1,1);
sol(2) = sol(1);
check(sol(1))=1;

f=0;
for k = 1:n-1
    fs=Inf;
    for i = 1:n
        for j = 1:k
            if check(i)==0
                if fs > d(sol(j),i) + d(i,sol(j+1)) - d(sol(j),sol(j+1))
                    fs = d(sol(j),i) + d(i,sol(j+1)) - d(sol(j),sol(j+1));
                    si = i;
                    sj = j;
                end
            end
        end
    end
    f=f+fs;
    sol(1:k+2)=[sol(1:sj) si sol(sj+1:k+1)];
    check(si)=1;
end

end