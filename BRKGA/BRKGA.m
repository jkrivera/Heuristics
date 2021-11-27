clear
format 'bank'

tic
[problem] = SeqGen(7,3,2);
toc

rng(27112016)

tic

npop=100;
pmut=0.1;
ngen=Inf;

% Initial population
best.F=Inf;
worst.F=0;
b=1;
w=1;
P(1).RK=zeros(1,problem.nrk);
P(1).ns=zeros(1,problem.m);
P(1).Seq=zeros(problem.m,1);
P(1).F=Inf;
H=P;
for i = 1:npop
    P(i).RK = rand(1,problem.nrk);
    P(i) = decode2(P(i),problem,best);
    if b==1 || P(b).F > P(i).F
        b=i;
        [0 i P(b).F toc]
    end
    if P(w).F < P(i).F
        w=i;
    end
end
best=P(b);
worst=P(w);
%[npop best.F worst.F toc]

g=0;
while g==g
    g=g+1;
    bh=1;
    for c=1:2:npop
        [p1,p2]=selection(P,npop,b,w);
        % First spring
        H(c)=crossover(P,p1,p2,problem.nrk);
        if rand < pmut
            H(c) = mutation(H(c),problem.nrk);
        end
        H(c)=decode2(H(c),problem,worst);
        if H(c).F<H(bh).F
            bh=c;
            if best.F > H(c).F
                best=H(c);
                [g c+(g-1)*npop best.F toc]
            end
        end
        % Second spring
        H(c+1)=crossover(P,p1,p2,problem.nrk);
        if rand < pmut
            H(c+1) = mutation(H(c+1),problem.nrk);
        end
        H(c+1)=decode2(H(c+1),problem,worst);
        if H(c+1).F<H(bh).F
            bh=c+1;
            if best.F > H(c+1).F
                best=H(c+1);
                [g c+1+(g-1)*npop best.F toc]
            end
        end
    end
    
    [P,worst,b,w,it] = updateP(P,H,npop,worst,b,w,bh);
    %[g best.F worst.F it toc]
end

toc
best.F