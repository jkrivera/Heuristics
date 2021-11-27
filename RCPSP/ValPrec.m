function f=ValPrec(sol, Prec, nprec, nt)

f=1;
for i=2:nt-1
    nprecused=0;
    for j=1:i-1
        if Prec(sol(j),sol(i))==1
            nprecused=nprecused+1;
        end
    end
    if nprec(sol(i))~=nprecused
        f=0;
        break
    end
end

end