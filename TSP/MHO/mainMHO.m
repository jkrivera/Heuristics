clear
clc
format 'bank';
[n,d] = readingTSP(2);
n

[sol,f]=constructive(n,d);

% tic
% 
% [sol,f] = LS(n,d,sol,f);
% 
% toc

% Parameters
npop = 100;
nrnd = 0;
tmax = 30;
nc = 100;
pmut = 0.2;
pmutde = 0.7;
F = 1;
c1=1.5;
c2=2;
w=1;

% tic
% [P,f,niter] = GA(n,d,npop,tmax,nc,pmut);
% [min(f) niter toc]

tic
[P,f,niter] = GARK(n,d,npop,tmax,nc,pmut,nrnd);
[min(f) niter toc]

% tic
% [P,f,niter] = DE(n,d,npop,tmax,pmutde,F);
% [min(f) niter toc]
% 
% tic
% [P,f,niter] = PSO(n,d,npop,tmax,c1,c2,w);
% [min(f) niter toc]

% tic
% [sol,f]=constr_rand(n,d,n);
% [sol,f,it] = ILS(n,d,sol,f,tmax);
% [f it toc]