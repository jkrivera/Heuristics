function [solucion] = makespan0(solucion, Prec, nprec, dur, rec, R, nrec, nt)

rectime=zeros(nrec,sum(dur));
ST=zeros(1,nt);
FT=zeros(1,nt);

for i=2:nt-1
    for j=1:i-1
        if Prec(solucion(j),solucion(i))==1
            if FT(solucion(j))>ST(solucion(i))
                ST(solucion(i))=FT(solucion(j));
            end
        end
    end
    
    t=ST(solucion(i))+1;
    while t<=ST(solucion(i))+dur(solucion(i))
        for r=1:nrec
            if rectime(r,t)+rec(r,solucion(i))>R(r,2)
                ST(solucion(i))=t;
                break;
            end
        end
        t=t+1;
    end
    FT(solucion(i))=ST(solucion(i))+dur(solucion(i));
    
    for t=ST(solucion(i))+1:ST(solucion(i))+dur(solucion(i))
        for r=1:nrec
            rectime(r,t)=rectime(r,t)+rec(r,solucion(i));
        end
    end
    
end

solucion(nt+1)=max(FT);

end