function sol=decode2(sol,problem,best)

sol.ns=zeros(1,problem.m);

sol.Seq=[];

sol.F=0;

[~,s] = sort(sol.RK);

for i=1:problem.nrk
    
    LB = ceil((sum(sol.ns)+problem.nrk-i+1)/problem.m);
    if LB >= best.F
        sol.F=Inf;
        break;
    end
    
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
        
        ins.dF=Inf;
        
        for h = 1:problem.m
            
            if seli<=factorial(problem.n)+problem.m-1
                if sol.ns(h)>0
                    k=sol.ns(h)+1;
                    for j = sol.ns(h)-problem.n+2:sol.ns(h)
                        if isempty(find(sol.Seq(h,j:sol.ns(h)) == 0))
                            if sol.Seq(h,j:sol.ns(h)) == problem.Seq(seli,1:sol.ns(h)-j+1)
                                k=j;
                                break;
                            end
                        else
                            if length(find(sol.Seq(h,j:sol.ns(h)) == 0))>1
                                sol.F=Inf;
                            else
                                if sum(sol.Seq(h,j:sol.ns(h))==problem.Seq(seli,1:sol.ns(h)-j+1)) == length(sol.Seq(h,j:sol.ns(h)))-1
                                    k=j;
                                    break;
                                end
                            end
                        end
                    end
                    if k + problem.n - 1 < LB
                        if ins.dF > problem.n - (sol.ns(h)+1-k) || (ins.dF==problem.n-(sol.ns(h)+1-k) && ins.F>k + problem.n - 1)
                            ins.dF=problem.n - (sol.ns(h)+1-k);
                            ins.sels=h;
                            ins.pos=k;
                            ins.L=problem.n-(sol.ns(h)-k+1);
                            ins.F=k + problem.n - 1;
                        end
                    end
                else
                    if ins.dF > problem.n || (ins.dF == problem.n && ins.F>problem.n)
                        ins.dF=problem.n;
                        ins.sels=h;
                        ins.pos=1;
                        ins.L=problem.n;
                        ins.F=problem.n;
                    end
                end
            else
                ins.dF=1;
                [~,ins.sels]=min(sol.ns);
                ins.pos=sol.ns(ins.sels)+1;
                ins.L=1;
                ins.F=sol.ns(ins.sels)+1;
                break;
            end
            
        end
        
        if seli<=factorial(problem.n)+problem.m-1
            sol.Seq(ins.sels,sol.ns(ins.sels)+1:sol.ns(ins.sels)+ins.L) = problem.Seq(seli,end-ins.L+1:end);
            sol.ns(ins.sels)=sol.ns(ins.sels)+ins.L;
            if sol.ns(ins.sels) > sol.F
                sol.F = sol.ns(ins.sels);
            end
        else
            sol.Seq(ins.sels,sol.ns(ins.sels)+1) = 0;
            sol.ns(ins.sels)=sol.ns(ins.sels)+1;
            if sol.ns(ins.sels) > sol.F
                sol.F = sol.ns(ins.sels);
            end
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