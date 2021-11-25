clear
clc
format 'bank';
[n,d] = readingTSP(2);

npop=100;
ngen=100;

tic
[RK,P,f] = GA(n,d,npop,ngen);
toc

tic
[RK,P,f] = GA2(n,d,npop,ngen);
toc