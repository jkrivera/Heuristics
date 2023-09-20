function Vec = Interchange(n,m,P,Rec,Sol,a,b)

Vec.id = Sol.id;
Vec.id(b) = Sol.id(a);
Vec.id(a) = Sol.id(b);

E = 1:n;

proc  = ones(1,n);
maq   = ones(1,m);

Vec.Seq  = zeros(m,n);
Vec.Pr   = zeros(n,m);
Vec.MaqS = zeros(m,n);
Vec.MaqF = zeros(m,n);
Vec.Cmax = 0;

for act = 1:n*m
    
    sel.job = find(E==Vec.id(act));

    if isempty(sel.job)
        Vec.Cmax = Inf;
        break;
    else

        i = sel.job;
        sel.job = E(i);
        E(i) = E(i)+n;
        if proc(i) <= m
            if proc(i) == 1
                start = max(Vec.MaqF(Rec(i,proc(i)),:));
                finish = start + P(i,proc(i));
            else
                start = max(Vec.finish(i,proc(i)-1),max(Vec.MaqF(Rec(i,proc(i)),:)));
                finish = start + P(i,proc(i));
            end
            sel.start = start;
            sel.finish = finish;
            sel.maq = Rec(i,proc(i));
        end

        Vec.Seq(sel.maq,maq(sel.maq)) = i;
        Vec.Pr(i,proc(i)) = act;
        Vec.start(i,proc(i)) = sel.start;
        Vec.finish(i,proc(i)) = sel.finish;
        Vec.MaqS(sel.maq,maq(sel.maq)) = sel.start;
        Vec.MaqF(sel.maq,maq(sel.maq)) = sel.finish;
        proc(i) = proc(i)+1;
        maq(sel.maq) = maq(sel.maq)+1;
    
        if proc(i) == m+1
            if sel.finish > Vec.Cmax
                Vec.Cmax = sel.finish;
            end
        end
    end
end

end