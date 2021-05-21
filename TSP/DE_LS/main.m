clear
clc
format 'bank';
[n,d] = readingTSP(2);

% Parameters
npop = 100;
tmax = 300;
nc = 100;
pmut = 0.05;
pmutDE = 0.2;
F = 1.5;

tic
[P,f,niter] = GA(n,d,npop,tmax,nc,pmut);
['GA']
[min(f) niter toc]

tic
[P,f,niter] = GARK(n,d,npop,tmax,nc,pmut);
['GARK']
[min(f) niter toc]

tic
[P,f,niter] = DE(n,d,npop,tmax,pmutDE,F);
['DE']
[min(f) niter toc]

tic
[P,f,niter] = DE_LS(n,d,npop,tmax,pmutDE,F);
['DE_LS']
[min(f) niter toc]