function [mak inicio rectime] = makespan(solucion, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt)
% La función makespan calcula el makespan (duración del proyecto) de un
% proyecto con recursos limitados (RCPSP).
%
% La función calcula las siguientes variables de salida:
% [mak]: makespan de la solucón (solucion)
% [inicio]: tiempo de inicio de cada actividad
% [rectime]: cantidad de recursos utilizados en cada intervalo de tiempo
% 
% Los parámetros de entrada son los siguientes:
% [solucion]: lista de actividades en el orden en que se van a programar
% [Prec]: Matriz de precedencias de las actividades (la entrada (i,j) vale
% 1 si la actividad i en precedencia de la actividad j; 0 en caso
% contrario)
% [nprec]: número de precedencias de cada actividad
% [duraciones]: duración de cada actividad
% [rec]: cada entrada (i,j) indica la cantidad de recursos que se requieren
% del tipo i para ejecutar la actividad j
% [cantidadRecursos]: cantidad de recursos disponibles de cada tipo
% [nrec]: número de tipos de recursos
% [nt]: número de actividades


rectime=zeros(nrec+1,1);

inicio=zeros(1,nt);

ntime=0;
for i=2:nt
% predes  va a ser la matriz que contenga todos lo predecesores de la
% i-ecima actividad
    if nprec(solucion(i))~=0
        usedprec=0;
        t=0;
        for i2=1:i
            if Prec(solucion(i2),solucion(i))==1
                if t<inicio(solucion(i2))+duraciones(solucion(i2))
                    t=inicio(solucion(i2))+duraciones(solucion(i2));
                end
                usedprec=usedprec+1;
                if usedprec==nprec(solucion(i))
                    break;
                end
            end
        end
    else
        t=0;
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
        if rectime(1,i3)<t+duraciones(solucion(i))
            for i2=1:nrec
                if rectime(i2+1,i3)+rec(i2,solucion(i))>cantidadRecursos(i2)
                    t=rectime(1,i3+1);
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
        rectime(1,i3)= t + duraciones(solucion(i));
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    elseif t+duraciones(solucion(i))==rectime(1,i3)
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    else
        rectime(:,i3:ntime+2)=rectime(:,i3-1:ntime+1);
        rectime(1,i3)= t + duraciones(solucion(i));
        ntime=ntime+1;
        for i5=i4:i3-1
            rectime(2:nrec+1,i5)=rectime(2:nrec+1,i5)+rec(:,solucion(i));
        end
    end
    inicio(solucion(i))=t;
end
mak=inicio(nt);

end