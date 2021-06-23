function error=validacion(soluciones, Prec, dur, nprec, nrec, rec, nt, Recu)

e=0;
error='';
Z=0;
racum=zeros(nrec,sum(dur));
PrecC=Prec;
ti(1:nt)=0;
tf(1:nt)=dur(1:nt);
for i=1:nt
    if sum(PrecC(:,soluciones(i)))~=0
        e=e+1;
        error(e).type=1;
        error(e).descripcion=['violacion de precedencia - actividad: ' num2str(soluciones(i))];
    end
    
    for j=1:soluciones(i)-1
        if Prec(j,soluciones(i))==1
            if ti(soluciones(i))<tf(j)
                ti(soluciones(i))=tf(j);
                tf(soluciones(i))=ti(soluciones(i))+dur(soluciones(i));
            end
        end
    end
    
    t=ti(soluciones(i))+1;
    while t<=tf(soluciones(i))
        for r=1:nrec
            if racum(r,t)+rec(r,soluciones(i))>Recu(r)
                ti(soluciones(i))=t;
                tf(soluciones(i))=ti(soluciones(i))+dur(soluciones(i));
                break;
            end
        end
        t=t+1;
    end
    
    for t=ti(soluciones(i))+1:tf(soluciones(i))
        for r=1:nrec
            racum(r,t)=racum(r,t)+rec(r,soluciones(i));
        end
    end
    
    if Z<tf(soluciones(i))
        Z=tf(soluciones(i));
    end
    
    PrecC(soluciones(i),:)=0;
    
end

if Z~=soluciones(nt+1)
    e=e+1;
    error(e).type=2;
    error(e).descripcion=['valor de función objetivo no concuerda'];
end    

end