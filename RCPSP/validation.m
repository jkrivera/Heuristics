function error=validation(S, Prec, dur, nprec, nrec, rec, nt, R)

e=0;
error='';
Z=0;
racum=zeros(nrec,sum(dur));
PrecC=Prec;
ti(1:nt)=0;
tf(1:nt)=dur(1:nt);
for i=1:nt
    if sum(PrecC(:,S.sol(i)))~=0
        e=e+1;
        error(e).type=1;
        error(e).descripcion=['violacion de precedencia - actividad: ' num2str(S.sol(i))];
    end
    
    for j=1:S.sol(i)-1
        if Prec(j,S.sol(i))==1
            if ti(S.sol(i))<tf(j)
                ti(S.sol(i))=tf(j);
                tf(S.sol(i))=ti(S.sol(i))+dur(S.sol(i));
            end
        end
    end
    
    t=ti(S.sol(i))+1;
    while t<=tf(S.sol(i))
        for r=1:nrec
            if racum(r,t)+rec(r,S.sol(i))>R(r)
                ti(S.sol(i))=t;
                tf(S.sol(i))=ti(S.sol(i))+dur(S.sol(i));
                break;
            end
        end
        t=t+1;
    end
    
    for t=ti(S.sol(i))+1:tf(S.sol(i))
        for r=1:nrec
            racum(r,t)=racum(r,t)+rec(r,S.sol(i));
        end
    end
    
    if ti(S.sol(i)) ~= S.St(S.sol(i))
        e=e+1;
        error(e).type=3;
        error(e).descripcion=['el tiempo de inicio de la actividad: ' num2str(S.sol(i)) ' no concuerda'];
    end
    
    if Z<tf(S.sol(i))
        Z=tf(S.sol(i));
    end
    
    PrecC(S.sol(i),:)=0;
    
end

if Z~=S.C
    e=e+1;
    error(e).type=2;
    error(e).descripcion=['valor de función objetivo no concuerda'];
end    

end