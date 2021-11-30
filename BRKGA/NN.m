function S=NN(problem)

S.RK=rand(1,problem.nrk);
check = zeros(1,problem.nrk);

for i=1:problem.m
    S.Seq(i,1)=i;
    S.ns(i)=problem.n;
    check(i)=1;
    S.nr(i) = 1;
end
S.F=problem.n;

nr = problem.m;

while nr < problem.nrk
    sel.n = 0;
    sel.F = Inf;
    sel.m = 1;
    sel.p = 0;
    fin = 0;
    for i = problem.m+1:problem.nrk
        if check(i)==0
            for k = 1:problem.m
                % At the beginning of the route
                if (problem.sav(i,S.Seq(k,1)) + S.ns(k) < sel.F) || (problem.sav(i,S.Seq(k,1)) + S.ns(k) == sel.F && problem.sav(i,S.Seq(k,1)) + S.ns(k) < problem.sav(i,S.Seq(sel.m,1))*(1-sel.p) + problem.sav(S.Seq(k,S.nr(k)),i)*sel.p + S.ns(sel.m)) || (problem.sav(i,S.Seq(k,1)) + S.ns(k) == sel.F && problem.sav(i,S.Seq(k,1)) + S.ns(k) == problem.sav(i,S.Seq(sel.m,1))*(1-sel.p) + problem.sav(S.Seq(k,S.nr(k)),i)*sel.p + S.ns(sel.m) && i~=sel.n && S.RK(i)<S.RK(sel.n))
                    sel.F = problem.sav(i,S.Seq(k,1)) + S.ns(k);
                    sel.n = i;
                    sel.m = k;
                    sel.p = 0;
                end
                % At the end of the route
                if (problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k) < sel.F) || (problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k) == sel.F && problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k) < problem.sav(i,S.Seq(sel.m,1))*(1-sel.p) + problem.sav(S.Seq(k,S.nr(k)),i)*sel.p + S.ns(sel.m)) || (problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k) == sel.F && problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k) < problem.sav(i,S.Seq(sel.m,1))*(1-sel.p) + problem.sav(S.Seq(k,S.nr(k)),i)*sel.p + S.ns(sel.m) && i~=sel.n && S.RK(i)<S.RK(sel.n))
                    sel.F = problem.sav(S.Seq(k,S.nr(k)),i) + S.ns(k);
                    sel.n = i;
                    sel.m = k;
                    sel.p = 1;
                end
            end
        end
    end
    
    % Update solution
    if sel.p == 0
        S.ns(sel.m) = sel.F;
        if sel.F > S.F
            S.F = sel.F;
        end
        S.Seq(sel.m,1:S.nr(sel.m)+1) = [sel.n S.Seq(sel.m,1:S.nr(sel.m))];
        S.nr(sel.m) = S.nr(sel.m)+1;
        check(sel.n) = 1;
        nr=nr+1;
    else
        S.ns(sel.m) = sel.F;
        if sel.F > S.F
            S.F = sel.F;
        end
        S.Seq(sel.m,1:S.nr(sel.m)+1) = [S.Seq(sel.m,1:S.nr(sel.m)) sel.n];
        S.nr(sel.m) = S.nr(sel.m)+1;
        check(sel.n) = 1;
        nr=nr+1;
    end
    
end

end