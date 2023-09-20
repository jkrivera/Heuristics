function Sol = Constructive(n,m,P,Rec)

proc  = ones(1,n);
maq   = ones(1,m);

Sol.Seq  = zeros(m,n);
Sol.Pr   = zeros(n,m);
Sol.MaqS = zeros(m,n);
Sol.MaqF = zeros(m,n);
Sol.Cmax = 0;

act = 0;
while act < n*m
    finish = 0;
    sel.job = 0;
    sel.start = Inf;
    sel.finish = Inf;
    sel.maq = 0;
    i=0;
    while i < n
        i = i+1;
        if proc(i) <= m
            if proc(i) == 1
                start = max(Sol.MaqF(Rec(i,proc(i)),:));
                finish = start + P(i,proc(i));
            else
                start = max(Sol.finish(i,proc(i)-1),max(Sol.MaqF(Rec(i,proc(i)),:)));
                finish = start + P(i,proc(i));
            end
            if finish <= sel.finish
                sel.job = i;
                sel.finish = finish;
                sel.start = start;
                sel.maq = Rec(i,proc(i));
            end
        end
    end
    act = act+1;
    Sol.Seq(sel.maq,maq(sel.maq)) = sel.job;
    Sol.Pr(sel.job,proc(sel.job)) = act;
    Sol.start(sel.job,proc(sel.job)) = sel.start;
    Sol.finish(sel.job,proc(sel.job)) = sel.finish;
    Sol.MaqS(sel.maq,maq(sel.maq)) = sel.start;
    Sol.MaqF(sel.maq,maq(sel.maq)) = sel.finish;
    proc(sel.job) = proc(sel.job)+1;
    maq(sel.maq) = maq(sel.maq)+1;

    if proc(sel.job) == m+1
        if sel.finish > Sol.Cmax
            Sol.Cmax = sel.finish;
        end
    end

end

for i = 1:n*m
    Sol.id(Sol.Pr(i))=i;
end

end