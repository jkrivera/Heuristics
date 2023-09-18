function [n,m,P,Rec]=readingJSSP(insid)

file=['JSSP' num2str(insid) '.txt'];
txt = textread(file);

n = txt(1,1);
m = txt(1,2);

P = txt(2:1+n,1:m);
Rec = txt(2+n:end,1:m);
end