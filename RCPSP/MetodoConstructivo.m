%Metodo constructivo
%Criterio de selecci�n: actividades con menor valor en par�metro 'criterio'
%Entradas: Prec, duraciones, nt
%Salidas: solucion
function [S]=MetodoConstructivo(Prec, criterio, nt)
solucion=zeros(1,nt); %Vector con el orden de las actividades
asignacion=zeros(1,nt); %Vector que permite saber cuales actividades ya han sido asignadas (las que tienen 1)
numActividad=0; %Actividad a ser asignada
Prec2=Prec;

%Asignacion de la 1era actividad (ficticia)
solucion(1)=1;
asignacion(1)=1;
Prec2(1,:)=zeros(1,nt); %Se elimina como precedencia porque ya se cumplio

%Asignacion de la ultima actividad (ficticia)
solucion(nt)=nt;
asignacion(nt)=1;

for i=2:(nt-1) %Se va construyendo el vector Solucion
    criterios=max(criterio)+1; %Duracion de la actividad a ser asignada. Se inicializa con valor grande.
    criterioTemp=0; %Duracion de la actividad que se esta analizando
    for j=2:(nt-1)
        if asignacion(j)==0 %Busca las actividades que no han sido asignadas
            if sum(Prec2(:,j))==0 %Busca que no tenga rest. de precedencia
                criterioTemp=criterio(j);
                if criterioTemp<criterios
                    criterios=criterioTemp;
                    numActividad=j;
                end
            end
        end
    end
    asignacion(round(numActividad))=1;
    solucion(i)=numActividad;
    Prec2(solucion(i),:)=zeros(1,nt);
end

S.sol=solucion;

end
