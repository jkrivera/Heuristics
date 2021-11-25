clc
clear

%% Starting...

nsol = 1000;
rng(30092021);
format bank

dur=['dura162.txt'];
dur=textread(dur);
dur=dur(:,2);

n=length(dur);

% durp=zeros(n,1);
% dsim=zeros(n,nsim);
% for i = 1:n
%     for s = 1:nsim
%         dsim(i,s)=max(round(dur(i)+2*randn(1)),1);
%     end
%     durp(i)=round(mean(dsim(i,:)),0);
% end

R=['recu162.txt'];
R=textread(R);
R=R(:,2);

m=length(R);

Pred=['pred162.txt'];
Pred=textread(Pred);

P=zeros(n,n);
for i = 1:size(Pred,1)
    P(Pred(i,1),Pred(i,2))=1;
end

clear pred;

core=['core162.txt'];
core=textread(core);

for i = 1:size(core,1)
    rec(core(i,1),core(i,2))=core(i,3);
end

clear core;

suc = zeros(n,4);
suc(:,1) = sum(P')';
nprec= sum(P);
prec = zeros(n,4);
prec(:,1) = nprec';

for i = 1:n
    x=find(P(i,:)==1);
    suc(i,2:1+length(x))=x;
    x=find(P(:,i)==1);
    prec(i,2:1+length(x))=x;
end

%% Solución

tic

Best = 1;
for h = 1:nsol
    Sol(h).S=1;
    nprecused=zeros(1,n);
    E=0;
    for i = 1:suc(1,1)
        nprecused(suc(1,i+1))=nprecused(suc(1,i+1))+1;
        if nprecused(suc(1,i+1))==nprec(suc(1,i+1))
            E(1)=E(1)+1;
            E(E(1)+1)=suc(1,i+1);
        end
    end
    
    for j=2:n
        sel=randi(E(1));
        Sol(h).S(j)=E(1+sel);
        E=[E(1:sel) E(sel+2:end)];
        E(1)=E(1)-1;
        for i = 1:suc(Sol(h).S(j),1)
            nprecused(suc(Sol(h).S(j),i+1))=nprecused(suc(Sol(h).S(j),i+1))+1;
            if nprecused(suc(Sol(h).S(j),i+1))==nprec(suc(Sol(h).S(j),i+1))
                E(1)=E(1)+1;
                E(E(1)+1)=suc(Sol(h).S(j),i+1);
            end
        end
    end
    
    Sol(h).rectime=zeros(m,sum(dur));
    Sol(h).St = zeros(1,n);
    
    for j=2:n
        
        for i = 1:prec(Sol(h).S(j),1)
            if Sol(h).St(Sol(h).S(j)) < Sol(h).St(prec(Sol(h).S(j),i+1)) + dur(prec(Sol(h).S(j),i+1))
                Sol(h).St(Sol(h).S(j)) = Sol(h).St(prec(Sol(h).S(j),i+1)) + dur(prec(Sol(h).S(j),i+1));
            end
        end
        
        t = Sol(h).St(Sol(h).S(j));
        while t <= Sol(h).St(Sol(h).S(j)) + dur(Sol(h).S(j))
            t=t+1;
            for k=1:m
                if Sol(h).rectime(k,t) + rec(k,Sol(h).S(j)) > R(k)
                    Sol(h).St(Sol(h).S(j)) = t;
                    break;
                end
            end
        end
        
        for t = Sol(h).St(Sol(h).S(j)) + 1 : Sol(h).St(Sol(h).S(j)) + dur(Sol(h).S(j))
            for k=1:m
                Sol(h).rectime(k,t) = Sol(h).rectime(k,t) + rec(k,Sol(h).S(j));
            end
        end
        
    end
    
    Sol(h).Z = Sol(h).St(n);
    
    Sol = Robustness(Sol,h,n,m,dur,P,nprec,suc,prec,R,rec);
    
    [Sol(h).Z Sol(h).R Sol(h).Rn];
    
    if Sol(Best).Z > Sol(h).Z
        Best = h;
    end
    
end
toc
[Best Sol(Best).Z]

for h=1:nsol
    if Sol(h).Z<Sol(Best).Z*(1+0.01)
        [Sol(h).Z Sol(h).R Sol(h).Rn]
    end
end
        