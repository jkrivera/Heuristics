clc
clear

%% Starting...

data=['pmsp.txt'];
data=textread(data);

nsim = 100;
nsol = 1000;
rng(30092021);
format bank

n=size(data,1);
m=5;
p=data(:,2)*5;

tic
pp=zeros(n,1);
psim=zeros(n,nsim);
for i = 1:n
    for s = 1:nsim
        psim(i,s)=max(round(p(i)+2*randn(1)),5);
    end
    pp(i)=mean(psim(i,:));
end
toc

%% Problema determinista
% 
% tic
% Best=1;
% for h = 1:nsol
%     Sol(h).Z=0;
%     check=zeros(1,n);
%     Sol(h).t=zeros(1,m);
%     Sol(h).n=zeros(1,m);
%     
%     for i=1:n
%         
%         sel=randi(n);
%         while check(sel)==1
%             sel=randi(n);
%         end
%         [~,msel]=min(Sol(h).t);
%         Sol(h).n(msel)=Sol(h).n(msel)+1;
%         Sol(h).S(msel,Sol(h).n(msel))=sel;
%         check(sel)=1;
%         Sol(h).t(msel)=Sol(h).t(msel)+p(sel);
%         if Sol(h).Z < Sol(h).t(msel)
%             Sol(h).Z = Sol(h).t(msel);
%         end
%     end
%     
%     if Sol(h).Z < Sol(Best).Z
%         Best = h;
%     end
%     
% end
% toc
% [Best Sol(Best).Z]
% BestD=Best;
% SolD=Sol;
% clear Sol;
% 
%% Problema determinista - Solución constructiva
% 
% tic
% 
% Sol.Z=0;
% check=zeros(1,n);
% Sol.t=zeros(1,m);
% Sol.n=zeros(1,m);
% 
% [~,po]=sort(p,'descend');
% 
% for i=1:n
%     [~,msel]=min(Sol.t);
%     Sol.n(msel)=Sol.n(msel)+1;
%     Sol.S(msel,Sol.n(msel))=po(i);
%     check(po(i))=1;
%     Sol.t(msel)=Sol.t(msel)+p(po(i));
%     if Sol.Z < Sol.t(msel)
%         Sol.Z = Sol.t(msel);
%     end
% end
% 
% toc
% [1 Sol.Z]
% SolC=Sol;
% clear Sol;
% 
%% Problema estocástico - Solución 1
% 
% tic
% Best=1;
% Sol=SolD;
% for h = 1:nsol
%     Sol(h).Z=0;
%     Sol(h).t=zeros(1,m);
%     for i=1:m
%         for j=1:Sol(h).n(i)
%             for s=1:nsim
%                 Sol(h).t(i)=Sol(h).t(i)+psim(Sol(h).S(i,j),s)/nsim;
%             end
%         end
%         if Sol(h).Z < Sol(h).t(i)
%             Sol(h).Z = Sol(h).t(i);
%         end
%     end
%     
%     if Sol(h).Z < Sol(Best).Z
%         Best = h;
%     end
% end
% toc
% [Best Sol(Best).Z]
% SolE=Sol;
% BestE=Best;
% 
%% Problema estocástico - Solución constructiva
% 
% tic
% Sol=SolC;
% Sol.Z=0;
% Sol.t=zeros(1,m);
% for i=1:m
%     for j=1:Sol.n(i)
%         for s=1:nsim
%             Sol.t(i)=Sol.t(i)+psim(Sol.S(i,j),s)/nsim;
%         end
%     end
%     if Sol.Z < Sol.t(i)
%         Sol.Z = Sol.t(i);
%     end
% end
% 
% toc
% [1 Sol.Z]
% SolEC=Sol;
% 
%% Problema estocástico - Solución 2
% 
% tic
% Best=1;
% Sol=SolD;
% for h = 1:nsol
%     Sol(h).Z=0;
%     Z=zeros(1,nsim);
%     for s=1:nsim
%         for i=1:m
%             t=0;
%             for j=1:Sol(h).n(i)
%                 t=t+psim(Sol(h).S(i,j),s);
%             end
%             if Z(s) < t
%                 Z(s) = t;
%             end
%         end
%     end
%     Sol(h).Z = mean(Z);
%     
%     if Sol(h).Z < Sol(Best).Z
%         Best = h;
%     end
% end
% toc
% [Best Sol(Best).Z]
% SolE2=Sol;
% BestE2=Best;
% 
%% Problema estocástico - Solución constructiva 2
% 
% tic
% Sol=SolC;
% Sol.Z=0;
% Sol.t=zeros(1,m);
% Z=zeros(1,nsim);
% for s=1:nsim
%     for i=1:m
%         t=0;
%         for j=1:Sol.n(i)
%             t=t+psim(Sol.S(i,j),s);
%         end
%         if Z(s) < t
%             Z(s) = t;
%         end
%     end
% end
% Sol.Z=mean(Z);
% 
% toc
% [1 Sol.Z]
% SolEC2=Sol;