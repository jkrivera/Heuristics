function [best bestinicio bestrectime]=knapsack_ls(soluciones, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt,inicio,rectime,PrecInd)

best=soluciones;
bestinicio=inicio;
bestrectime=rectime;
elegible=[];
for i1=1:size(rectime,2)-1
    % Buscar actividades terminadas
    finished=[];
    check=zeros(1,nt);
    for i2=1:nt-1
        if inicio(i2)+duraciones(i2,2)<=rectime(1,i1)
            finished=[finished i2];
        end
    end
    % Buscar actividades elegibles
    for i2=2:nt-1
        if inicio(i2)<=rectime(1,i1) && inicio(i2)+duraciones(i2,2)>rectime(1,i1)
%             if isempty(elegible)
%                 elegible=i2;
%             else
                elegible=[elegible i2];
                check(i2)=1;
%             end
        else
            if inicio(i2)>rectime(1,i1)
                nprecused=0;
                for i3=size(finished,2):-1:1
                    if Prec(finished(i3),i2)==1
                        nprecused=nprecused+1;
                        if nprecused==nprec(i2)
                            elegible=[elegible i2];
                            check(i2)=1;
                            break;
                        end
                    end
                end
            end
        end
    end

    % Optimizar el conjunto
    c=check.*sum(rec);
    A=rec;
    A(1,:)=A(1,:)+(max(max(cantidadRecursos))+1)*(1-check);
    x=bintprog(-c,A,cantidadRecursos(:,2));
    
    %Generar vecino
    vecino=[finished find(x'==1)];
    for i2=1:nt
        if isempty(find(vecino==soluciones(i2)))
            vecino(size(vecino,2)+1)=soluciones(i2);
        end
    end
    vecino(nt+1)=0;
    [vecino vecinicio vecrectime]=makespan(soluciones, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt); %Eval?a la f.o.
    if vecino(nt+1)<best(nt+1)
        best=vecino;
        bestinicio=vecinicio;
        bestrectime=vecrectime;
    end
    
    elegible=[];
end

end