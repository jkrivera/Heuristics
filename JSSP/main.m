%clear
clc
format 'bank';

for ins = 1:16
    [n,m,P,Rec] = readingJSSP(1);
    
    [Sol] = Constructive(n,m,P,Rec);
end
