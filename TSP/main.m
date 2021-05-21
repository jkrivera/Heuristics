%clear
clc
format 'bank';
p=2;
[n,d] = readingTSP(p);

% Active methods
active = zeros(1,4);
active(1) = 0; % GA
active(2) = 0; % GARK
active(3) = 0; % DE
active(4) = 1; % DE + LS

% Parameters
tmax = 300;
npop = 100;
nc = 100;
pmut = 0.05;
pmutDE = 0.2;
F = 1.5;

m=1; % ********** Genetic Algorithm **********
if active(m)==1
    tic
    [P,f,niter] = GA(n,d,npop,tmax,nc,pmut);
    output(p,m).t    = toc;
    output(p,m).met  = 'GA';
    output(p,m).f    = min(f);
    output(p,m).iter = niter;
end

m=2; % ********** Genetic Algorithm with Random Keys **********
if active(m)==1
    tic
    [P,f,niter] = GARK(n,d,npop,tmax,nc,pmut);
    output(p,m).t    = toc;
    output(p,m).met  = 'GARK';
    output(p,m).f    = min(f);
    output(p,m).iter = niter;
end

m=3; % ********** Differential Evolution **********
if active(m)==1
    tic
    [P,f,niter] = DE(n,d,npop,tmax,pmutDE,F);
    output(p,m).t    = toc;
    output(p,m).met  = 'DE';
    output(p,m).f    = min(f);
    output(p,m).iter = niter;
end

m=4; % ********** Differential Evolution + Local Search **********
if active(m)==1
    tic
    [P,f,niter] = DE_LS(n,d,npop,tmax,pmutDE,F);
    output(p,m).t    = toc;
    output(p,m).met  = 'DE_LS';
    output(p,m).f    = min(f);
    output(p,m).iter = niter;
end