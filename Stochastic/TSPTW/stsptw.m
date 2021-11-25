clc
clear

%% Starting...

data=['tsptw150.txt'];
data=textread(data);

nsim = 100;
nsol = 10000;
rng(30092021);
format bank

n=size(data,1);
a=data(:,4);
b=data(:,5)*2.5;

tic
d=zeros(n,n);
dp=zeros(n,n);
dsim=zeros(n,n,nsim);
for i = 1:n
    for j = i+1:n
        d(i,j)=sqrt((data(i,2)-data(j,2))^2+(data(i,3)-data(j,3))^2);
        d(j,i)=d(i,j);
        for s = 1:nsim
            dsim(i,j,s)=d(i,j)+0.02*d(i,j)*randn(1,1);
            dsim(j,i,s)=d(j,i)+0.02*d(j,i)*randn(1,1);
        end
        dp(i,j)=mean(dsim(i,j,:));
        dp(j,i)=mean(dsim(j,i,:));
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
    Sol(h).R=0;
    t=0;
    
    for i=2:n
        sel=randi(150);
        while check(sel)==1
            sel=randi(150);
        end
        Sol(h).S(i)=sel;
        check(sel)=1;
        Sol(h).Z=Sol(h).Z+d(Sol(h).S(i-1),Sol(h).S(i));
        t=t+d(Sol(h).S(i-1),Sol(h).S(i));
        if t<a(sel)
            t=a(sel);
        end
        if t>b(sel)
            Sol(h).R=Sol(h).R+1;
        end
    end
    Sol(h).S(n+1)=1;
    Sol(h).Z=Sol(h).Z+d(Sol(h).S(n),Sol(h).S(n+1));
    Sol(h).R=Sol(h).R/n;
    
    if Sol(h).R<Sol(Best).R
        Best=h;
    else
        if Sol(h).R==Sol(Best).R && Sol(h).Z<Sol(Best).R
            Best=h;
        end
    end
end
toc
[Best Sol(Best).R Sol(Best).Z]
BestD=Best;
SolD=Sol;

%% Problema estocástico

% tic
% Best=1;
% for h = 1:nsol
%     Sol(h).Z=0;
%     Sol(h).R=0;
%     for s=1:nsim
%         t=0;
%         for i=2:n+1
%             Sol(h).Z=Sol(h).Z+dsim(Sol(h).S(i-1),Sol(h).S(i),s);
%             t=t+dsim(Sol(h).S(i-1),Sol(h).S(i),s);
%             if t<a(sel)
%                 t=a(sel);
%             end
%             if t>b(sel)
%                 Sol(h).R=Sol(h).R+1;
%             end
%         end
%     end
%     Sol(h).Z=Sol(h).Z/nsim;
%     Sol(h).R=Sol(h).R/nsim/n;
%     
%     if Sol(h).R<Sol(Best).R
%         Best=h;
%     else
%         if Sol(h).R==Sol(Best).R && Sol(h).Z<Sol(Best).R
%             Best=h;
%         end
%     end
% end
% toc
% [Best Sol(Best).R Sol(Best).Z]
% BestE=Best;
% SolE=Sol;

%% Problema estocástico son solución determinista

tic
Best=1;
for h = 1:nsol
    Sol(h).Z=0;
    Sol(h).R=0;
    t=0;
    for i=2:n+1
        Sol(h).Z=Sol(h).Z+dp(Sol(h).S(i-1),Sol(h).S(i));
        t=t+dp(Sol(h).S(i-1),Sol(h).S(i));
        if t<a(sel)
            t=a(sel);
        end
        if t>b(sel)
            Sol(h).R=Sol(h).R+1;
        end
    end
    Sol(h).R=Sol(h).R/n;
    
    if Sol(h).R<Sol(Best).R
        Best=h;
    else
        if Sol(h).R==Sol(Best).R && Sol(h).Z<Sol(Best).R
            Best=h;
        end
    end
end
toc
[Best Sol(Best).R Sol(Best).Z]