function sol=decode(sol,problem,best)

sol.ns=zeros(problem.m,1);

sol.Seq=[];

sol.F=0;

[~,s] = sort(sol.RK);

for i=1:problem.nrk
    seli = s(i);
    fnd=0;
    for j = 1: problem.m
        for h = 2:sol.ns(j)-7
            if isempty(find(sol.Seq(j,h:h+6)==0))
                if problem.Seq(seli,:) == sol.Seq(j,h:h+6)
                    fnd=1;
                    break;
                end
            else
                if length(find(sol.Seq(j,h:h+6)==0))>1
                    fnd=1;
                    sol.F=Inf;
                    break;
                else
                    if sum(sol.Seq(j,h:h+6)==problem.Seq(seli,:)) == problem.n-1
                        fnd=1;
                        break;
                    end
                end
            end
        end
        if fnd==1
            break;
        end
    end
    
    if fnd==0
        j=i+1;
        while seli > factorial(problem.n)+problem.m-1 && i <= problem.m
            s(i)=s(j);
            s(j)=seli;
            seli=s(i);
            j=j+1;
        end
        if seli<=problem.m
            sels=seli;
        else
            [~,sels] = min(sol.ns);
        end
        if seli<=factorial(problem.n)+problem.m-1
            if sol.ns(sels)>0
                k=sol.ns(sels)+1;
                for j = sol.ns(sels)-problem.n+2:sol.ns(sels)
                    if isempty(find(sol.Seq(sels,j:sol.ns(sels)) == 0))
                        if sol.Seq(sels,j:sol.ns(sels)) == problem.Seq(seli,1:sol.ns(sels)-j+1)
                            k=j;
                            break;
                        end
                    else
                        if length(find(sol.Seq(sels,j:sol.ns(sels)) == 0))>1
                            sol.F=Inf;
                        else
                            if sum(sol.Seq(sels,j:sol.ns(sels))==problem.Seq(seli,1:sol.ns(sels)-j+1)) == length(sol.Seq(sels,j:sol.ns(sels)))-1
                                sol.Seq(sels,k:j+problem.n-1) = problem.Seq(seli,1+k-j:end);
                            end
                        end
                    end
                end
                sol.Seq(sels,k:k+problem.n-1)=problem.Seq(seli,:);
                sol.ns(sels)=k+problem.n-1;
                if sol.F < sol.ns(sels)
                    sol.F = sol.ns(sels);
                end
            else
                sol.ns(sels)=problem.n;
                sol.Seq(sels,1:problem.n)=problem.Seq(seli,:);
                sol.F=problem.n;
            end
        else
            k=sol.ns(sels);
            sol.Seq(sels,k)=0;
        end
        if sol.F >= 100000
            break;
        end
        if sol.F >= best.F
            break;
        end
    end
end

end