function [solucion inicio] = makespan(solucion, Prec, nprec, duraciones, rec, predecesor, cantidadRecursos, nrec, nt)
%% Empieza makespan
i=1;
j=1;
rectime=zeros(nrec+1,1);

inicio=zeros(1,nt);

ntime=0;
currenttime=0;
for i=2:nt
% predes  va a ser la matriz que contenga todos lo predecesores de la
% i-ecima actividad
    if nprec(solucion(i))~=0
        usedprec=0;
        t=currenttime;
        for i2=1:i
            if Prec(solucion(i2),solucion(i))==1
                if t<inicio(solucion(i2))+duraciones(solucion(i2),2)
                    t=inicio(solucion(i2))+duraciones(solucion(i2),2);
                    currenttime=t;
                end
                usedprec=usedprec+1;
                if usedprec==nprec(solucion(i))
                    break;
                end
            end
        end
    else
        t=currenttime;
    end
%     Cálculo del tiempo de inicio basado en recursos
% 		Mientras el tiempo sea menor que el tiempo de finalización
    
    for i3=1:nt
        if rectime(1,i3)== t
            break
        end
    end
    i4=i3;
    while size(rectime,2)>= i3
        if rectime(1,i3)<t+duraciones(solucion(i),2)
            for i2=1:nrec
                if rectime(i2+1,i3)+rec(i2,solucion(i))>cantidadRecursos(i2,2)
                    t=rectime(1,i3+1);
                    currenttime=t;
                    i4=i3+1;
                    break;
                end
            end
            i3=i3+1;
        else
            break;
        end
    end
    
    if size(rectime,2)<i3
        ntime=ntime+1;
        rectime(:,ntime+1:i3)=rectime(:,ntime:i3-1);
        rectime(1,i3)= t + duraciones(solucion(i),2);
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    elseif t+duraciones(solucion(i),2)==rectime(1,i3)
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    else
        rectime(:,i3:ntime+2)=rectime(:,i3-1:ntime+1);
        rectime(1,i3)= t + duraciones(solucion(i),2);
        ntime=ntime+1;
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    end
    inicio(solucion(i))=t;
end
solucion(nt+1)=inicio(nt);

end