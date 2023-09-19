function Sol = Constructive(n,m,P,Rec)

t     = zeros(n,m);
check = zeros(n,m);
proc  = ones(1,n);
maq   = ones(1,m);

Sol.S = zeros(n,m);

act = 0;
while act < n*m
    fin = 0;
    sel.job = 0;
    sel.inicio = Inf;
    sel.fin = Inf;
    i=0;
    while sel.job <= n
        i = i+1;
        if proc(i) == 1
            inicio = t(Rec(i,proc(i)),maq(Rec(i,proc(i))));
            fin = inicio + P(i,proc(i));
        end
        if fin <= sel.fin
            sel.job = i;
            sel.fin = fin;
            sel.inicio = inicio;
        end
    end
end

end