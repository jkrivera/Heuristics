function [RK,P,f]=GA(n,d,npop,ngen)

RK = [zeros(npop,1) rand(npop,n-1)];
[~, P] = sort(RK');
P=P';
P(:,end+1)=P(:,1);
f=objectives(P,n,d,npop);
r=ranking(f,npop);
x=find(r==1);
plot(f(x,1),f(x,2),'.')
hold on

for g=1:ngen
    for c=1:2:npop
        [p1,p2]=Selection(r,npop);
        [RK(npop+c,:),RK(npop+c+1,:)]=Cruce(RK,p1,p2,n);
        if rand<0.1
            y=randi(2)-1;
            RK(npop+c+y,:)=Mutacion(RK,npop+c+y,n);
        end
    end
    [~, Pp] = sort(RK(npop+1:end,:)');
    P(npop+1:npop*2,1:end-1)=Pp';
    P(:,end)=P(:,1);
    f=objectives(P,n,d,2*npop);
    r=ranking(f,2*npop);
    [RK,P,f,r]=Actualizacion(RK,P,f,2*npop,r,npop);
    
    if g==20 || g==50 || g==100
        x=find(r==1);
        plot(f(x,1),f(x,2),'.')
        if g==100
            f(x,:)
        end
    end

end

end