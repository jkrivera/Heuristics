%clear
clc
format 'bank';

RC = [];
RI = [];

for ins = 0:16
    [n,m,P,Rec] = readingJSSP(ins);
    
    tic
    [Sol] = Constructive(n,m,P,Rec);
    t0 = toc;

    [Imp,it] = LocalSearch(n,m,P,Rec,Sol);
    RI = [RI;ins Sol.Cmax t0 Imp.Cmax (Sol.Cmax-Imp.Cmax)/Sol.Cmax*100 it toc]
end