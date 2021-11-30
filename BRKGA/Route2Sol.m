function bestSol=Route2Sol(best,problem)

bestSol.ns=zeros(1,problem.m);
bestSol.Seq=zeros(problem.m,best.F);

for k=1:problem.m
    for i = 1:best.nr(k)
        if bestSol.ns(k)==0
            for j=1:problem.n
                bestSol.Seq(k,j)=problem.Seq(best.Seq(k,i),j);
                bestSol.ns(k)=bestSol.ns(k)+1;
            end
        else
            for h = problem.n-2:-1:2
                if problem.Seq(best.Seq(k,i),1:h+1) == bestSol.Seq(k,bestSol.ns(k)-h:bestSol.ns(k))
                    break;
                end
            end
            for j = h+2:problem.n
                bestSol.ns(k)=bestSol.ns(k)+1;
                bestSol.Seq(k,bestSol.ns(k))=problem.Seq(best.Seq(k,i),j);
            end
        end
    end
end

end