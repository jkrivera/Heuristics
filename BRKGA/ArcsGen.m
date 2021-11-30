function [problem] = ArcsGen(problem)

for i = 1:problem.nrk
    for j = 1:problem.nrk
        if i~=j
            if i > problem.nrk - problem.k || j > problem.nrk - problem.k
                if i > problem.nrk - problem.k || j > problem.nrk - problem.k
                    problem.sav(i,j) = problem.n;
                else
                    problem.sav(i,j) = 1;
                end
            else
                selk=0;
                for k = 1:problem.n-1
                    if problem.Seq(i,k+1:end) == problem.Seq(j,1:end-k)
                        selk=k;
                        break;
                    end
                end
                if selk==0
                    problem.sav(i,j) = problem.n;
                else
                    problem.sav(i,j) = selk;
                end
            end
        end
    end
end

end