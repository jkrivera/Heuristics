clear
format 'bank'

tic
[problem] = SeqGen(6,3,2);
toc

tic
[problem] = ArcsGen(problem);
toc

rng(27112016)

tic

maxit=100;
best.F=Inf;
% worst.F=0;

for it = 1:maxit
    S=NN(problem);
    if S.F < best.F
        best=S;
        bestSol=Route2Sol(best,problem);
        [it best.F toc]
    end
%     if S.F > worst.F
%         worst=S;
%     end
end
[it best.F toc]