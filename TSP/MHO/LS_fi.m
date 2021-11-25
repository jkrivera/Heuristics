function [sol,f] = LS_fi(n,d,sol,f)

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
            if f>fv+0.001
                f=fv;
                sol=vec;
                fin=0;
            end
            if fin==0
                break;
            end
        end
        if fin==0
            break;
        end
    end
end

end