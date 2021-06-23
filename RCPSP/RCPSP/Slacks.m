function [sol,Z]=Slacks(nt,dur,Prec,nprec,nsuc,nrec,rec,recu)

check=zeros(1,nt);
check(1)=1;
sol=1;
ES=zeros(1,nt);
EF=zeros(1,nt);
npprog=zeros(1,nt);
nsprog=zeros(1,nt);
lowert=0;
change=1;
deltat=0;
elegibles=0;
nprece=zeros(1,nt);
Z=0;
racum=zeros(nrec,sum(dur));

for sel=1:nt-1
    if change==1
        for i=2:nt
            if check(i)==0 && ES(i)>=lowert
                for j=1:i-1
                    if Prec(j,i)==1
                        npprog(i)=npprog(i)+1;
                        nsprog(j)=nsprog(j)+1;
                        if ES(i)<EF(j)
                            ES(i)=EF(j);
                        end
                        if npprog(i)==nprec(i)
                            break;
                        end
                    end
                end
            end
            EF(i)=ES(i)+dur(i);
        end
        
        LF(nt)=EF(nt);
        LS(nt)=EF(nt);
        deltat=EF(nt)-Z;
        Z=EF(nt);
        npprog=zeros(1,nt);
        nsprog=zeros(1,nt);
        
        for i=nt-1:-1:1
            if check(i)==0 && deltat>0
                LF(i)=LF(nt);
                for j=i+1:nt
                    if Prec(i,j)==1
                        nsprog(i)=nsprog(i)+1;
                        if LF(i)>LS(j)
                            LF(i)=LS(j);
                        end
                        if nsprog(i)==nsuc(i)
                            break;
                        end
                    end
                end
            end
            LS(i)=LF(i)-dur(i);
        end
        Slack=LS-ES;
    end
    
    nsprog=zeros(1,nt);
    for i=sol(sel)+1:nt
        if Prec(sol(sel),i)==1
            nprece(i)=nprece(i)+1;
            nsprog(sol(sel))=nsprog(sol(sel))+1;
            if nprece(i)==nprec(i)
                elegibles(1)=elegibles(1)+1;
                elegibles(elegibles(1)+1)=i;
            end
            if nsprog(sol(sel))==nsuc(sol(sel))
                break;
            end
        end
    end
    
    vslack=0;
    for i=2:elegibles(1)+1
        if vslack==0 || Slack(elegibles(i))<Slack(vslack)
            vslack=elegibles(i);
            pslack=i;
        end
    end
    
    lowert=ES(vslack);
    t=ES(vslack)+1;
    while t<=ES(vslack)+dur(vslack)
        for k=1:nrec
            if racum(k,t)+rec(k,vslack)>recu(k)
                ES(vslack)=t;
                break;
            end
        end
        t=t+1;
    end
    
    if EF(vslack)==ES(vslack)+dur(vslack)
        change=0;
    else
        change=1;
        EF(vslack)=ES(vslack)+dur(vslack);
    end
    for t=ES(vslack)+1:EF(vslack)
        for k=1:nrec
            racum(k,t)=racum(k,t)+rec(k,vslack);
        end
    end
    sol(sel+1)=vslack;
    Slack(vslack)=0;
    check(vslack)=1;
    elegibles=[elegibles(1:pslack-1) elegibles(pslack+1:elegibles(1)+1)];
    elegibles(1)=elegibles(1)-1;
        
end

end