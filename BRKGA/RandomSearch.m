clear
format 'bank'

tic
[problem] = SeqGen(7,3,2);
toc

rng(27112016)

tic

nsol=1000;
it=0;
best.F=Inf;
worst.F=0;
while it<nsol
    it=it+1;

    sol.RK=rand(1,problem.nrk);

    sol=decode2(sol,problem,best);
    if best.F > sol.F
        best=sol;
%         [it best.F worst.F]
    end
    if worst.F < sol.F && sol.F<Inf
        worst=sol;
%         [it best.F worst.F]
    end
    
    [it best.F worst.F toc]

end

toc
best.F