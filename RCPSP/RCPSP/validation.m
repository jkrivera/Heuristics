function validation(sol,Z,nt,nprec,Prec,dur,nrec,rec,recu)

ES=zeros(1,nt);
LS=zeros(1,nt);
npprog=zeros(1,nt);
racum=zeros(nrec,sum(dur));
for i=1:nt
    for j=1:i-1
        if Prec(sol(j),sol(i))==1
            npprog(sol(i))=npprog(sol(i))+1;
        end
    end
    if npprog(sol(i))~=nprec(sol(i))
        i=i;
    end
    for j=sol(i)+1:nt
        if Prec(sol(i),j)==1
            if ES(j)<LS(sol(i))
                ES(j)=LS(sol(i));
            end
            LS(j)=ES(j)+dur(j);
        end
    end
    
    t=ES(sol(i))+1;
    while t <= ES(sol(i))+dur(sol(i))
        for k=1:nrec
            if racum(k,t)+rec(k,sol(i))>recu(k)
                ES(sol(i))=t;
                LS(sol(i))=ES(sol(i))+dur(sol(i));
                break;
            end
        end
        t=t+1;
    end
    for t=ES(sol(i))+1:ES(sol(i))+dur(sol(i))
        for k=1:nrec
            racum(k,t)=racum(k,t)+rec(k,sol(i));
        end
    end
    
    for j=sol(i)+1:nt
        if Prec(sol(i),j)==1
            if ES(j)<LS(sol(i))
                ES(j)=LS(sol(i));
            end
            LS(j)=ES(j)+dur(j);
        end
    end
    
end

if Z~=LS(nt)
    nt=nt;
end

end