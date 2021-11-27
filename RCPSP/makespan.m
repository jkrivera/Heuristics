function V = makespan(V, Prec, nprec, dur, rec, R, nrec, nt)
%% Makespan

rectime=zeros(nrec+1,1);

V.St=zeros(1,nt);

ct=0;
for i=2:nt
    usedprec=0;
    t=0;
    for j=1:i
        if Prec(V.sol(j),V.sol(i))==1
            if t<V.St(V.sol(j))+dur(V.sol(j))
                t=V.St(V.sol(j))+dur(V.sol(j));
            end
            usedprec=usedprec+1;
            if usedprec==nprec(V.sol(i))
                break;
            end
        end
    end
    %     Cálculo del tiempo de inicio basado en recursos
    % 		Mientras el tiempo sea menor que el tiempo de finalización
    
    for j=1:nt
        if rectime(1,j)== t
            break
        end
    end
    
    k=j;
    while size(rectime,2)>= j
        if rectime(1,j)<t+dur(V.sol(i))
            for r=1:nrec
                if rectime(r+1,j)+rec(r,V.sol(i))>R(r)
                    t=rectime(1,j+1);
                    k=j+1;
                    break;
                end
            end
            j=j+1;
        else
            break;
        end
    end
    
    if size(rectime,2)<j
        ct=ct+1;
        rectime(:,ct+1:j)=rectime(:,ct:j-1);
        rectime(1,j)= t + dur(V.sol(i));
        for h=k:j-1
            rectime(2:nrec+1,h)=rectime(2:nrec+1,h)+rec(:,V.sol(i));
        end
    elseif t+dur(V.sol(i))==rectime(1,j)
        for h=k:j-1
            rectime(2:nrec+1,h)=rectime(2:nrec+1,h)+rec(:,V.sol(i));
        end
    else
        rectime(:,j:ct+2)=rectime(:,j-1:ct+1);
        rectime(1,j)= t + dur(V.sol(i));
        ct=ct+1;
        for h=k:j-1
            rectime(2:nrec+1,h)=rectime(2:nrec+1,h)+rec(:,V.sol(i));
        end
    end
    V.St(V.sol(i))=t;
end
V.C = V.St(nt);

end