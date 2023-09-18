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
    i=0;
    while sel.job <= n && fin == 0
        i = i+1;
        if proc(i) == 1
            inicio = t(Rec(i,proc(i)),maq(Rec(i,proc(i))));
            fin = inicio + P(i,Rec(i,proc(i)));
        end
    end
end

end