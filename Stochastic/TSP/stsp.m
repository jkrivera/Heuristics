clc
clear

data=['tsp150.txt'];
data=textread(data);

nsim = 1000;
nsol = 1000;
rng(30092021);
format bank

n=size(data,1);

tic
d=zeros(n,n);
dsim=zeros(n,n,nsim);
for i = 1:n
    for j = i+1:n
        d(i,j)=sqrt((data(i,2)-data(j,2))^2+(data(i,3)-data(j,3))^2);
        d(j,i)=d(i,j);
        for s = 1:nsim
            dsim(i,j,s)=d(i,j)+0.02*d(i,j)*randn(1,1);
            dsim(j,i,s)=d(i,j)+0.02*d(i,j)*randn(1,1);
        end
        dp(i,j)=mean(d(i,j,:));
        dp(j,i)=mean(d(j,i,:));
    end
end
toc

%% Problema determinista

tic
Best=1;
for h = 1:nsol
    check=zeros(1,n);
    check(1)=1;
    Sol(h).S=1;
    Sol(h).Z=0;
    
    for i=2:n
        sel=randi(150);
        while check(sel)==1
            sel=randi(150);
        end
        Sol(h).S(i)=sel;
        check(sel)=1;
        Sol(h).Z=Sol(h).Z+d(Sol(h).S(i-1),Sol(h).S(i));
    end
    Sol(h).S(n+1)=1;
    Sol(h).Z=Sol(h).Z+d(Sol(h).S(n),Sol(h).S(n-1));
    
    if Sol(h).Z<Sol(Best).Z
        Best=h;
    end
end
toc
[Best Sol(Best).Z]
BestD=Best;
SolD=Sol;

%% Problema estocástico

% tic
% Best=1;
% for h = 1:nsol
%     check=zeros(1,n);
%     check(1)=1;
%     Sol(h).S=1;
%     Sol(h).Z=0;
%     
%     for i=2:n
%         
%         sel=randi(150);
%         while check(sel)==1
%             sel=randi(150);
%         end
%         Sol(h).S(i)=sel;
%         check(sel)=1;
%         for s=1:nsim
%             Sol(h).Z=Sol(h).Z+dsim(Sol(h).S(i-1),Sol(h).S(i),s)/nsim;
%         end
%     end
%     Sol(h).S(n+1)=1;
%     for s=1:nsim
%         Sol(h).Z=Sol(h).Z+dsim(Sol(h).S(n),Sol(h).S(n+1),s)/nsim;
%     end
%     
%     if Sol(h).Z<Sol(Best).Z
%         Best=h;
%     end
% end
% toc
% [Best Sol(Best).Z]

%% Problema estocástico con solución determinista

% tic
% Best=1;
% Sol=SolD;
% for h = 1:nsol
%     Sol(h).Z=0;
%     for i=2:n+1
%         for s=1:nsim
%             Sol(h).Z=Sol(h).Z+dsim(Sol(h).S(i-1),Sol(h).S(i),s)/nsim;
%         end
%     end
%     
%     if Sol(h).Z<Sol(Best).Z
%         Best=h;
%     end
% end
% toc
% [Best Sol(Best).Z]


tic
Best=1;
Sol=SolD;
for h = 1:nsol
    Sol(h).Z=0;
    for i=2:n+1
        Sol(h).Z=Sol(h).Z+dp(Sol(h).S(i-1),Sol(h).S(i));
    end
    
    if Sol(h).Z<Sol(Best).Z
        Best=h;
    end
end
toc
[Best Sol(Best).Z]