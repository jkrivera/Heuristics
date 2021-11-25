function [sol,f]=constr_rand(n,d,Kmax)

sol=zeros(1,n+1);
check=zeros(1,n);

sol(1) = randi(n,1,1);
check(sol(1))=1;

f=0;
for k = 2:n
    [~,srtid]=sort(d(sol(k-1),:));
    h=0;
    RCL=zeros(1,Kmax);
    nRCL=0;
    while nRCL<Kmax && h<n
        h=h+1;
        if check(srtid(h))==1
%             srtid(h+1)=[];
        else
            nRCL=nRCL+1;
            RCL(nRCL)=srtid(h);
        end
    end
%     if length(srtid)>Kmax
%         srtid(Kmax+1:end)=[];
%     end
    r=randi(nRCL,1,1);
    sol(k)=RCL(r);
    check(RCL(r))=1;
    f=f+d(sol(k-1),sol(k));
end
sol(n+1)=sol(1);
f=f+d(sol(n),sol(n+1));

end