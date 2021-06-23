function lb=CPM(Prec, duraciones, nt)

ES=zeros(1,nt);
EF=zeros(1,nt);
LF=zeros(1,nt);


%compute the early start and the early finish
for j=2:nt
    ES(j)=max(EF.*Prec(:,j)');
    EF(j)=ES(j)+duraciones(j);
end

lb=EF(nt);

end