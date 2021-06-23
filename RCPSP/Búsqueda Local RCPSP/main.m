function soluciones=main
% Ejemplos:
% - Mínima duración
% - Máxima duración
% - Solución Lexicográfica
% - Indice de recursos
% - Solución Aleatoria


clear all

duracion=['datos30\dura1310.txt']; %Duracion de cada actividad (Act. - Dur.)
recursos=['datos30\core1310.txt']; %Consumo de recursos por actividad (Rec. - Act. - Cons.)
predecesores=['datos30\pred1310.txt']; %Restricciones de precedencia de actividades (Act. antes - Act. Desp.)
cantidadRecursos=['datos30\recu1310.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
duraciones=textread(duracion); %dura
recursos=textread(recursos); % core
predecesor=textread(predecesores); %pred
cantidadRecursos=textread(cantidadRecursos);  %recu

nt=size(duraciones,1);
nrec=size(recursos,1)/nt;
for i = 1:length(recursos)
    rec(recursos(i,1),recursos(i,2))=recursos(i,3);
end
Prec=zeros(nt,nt);	%es un arreglo (nt x nt) que indica si una actividad es
% precedencia de otra (1) o no (0). 

for i=1:size(predecesor,1)
    Prec(predecesor(i),predecesor(i,2))=1;
end
nprec=zeros(1,nt);
for i=1:nt
    nprec(i)=sum(Prec(:,i));%es un vector con nt componentes que indica el
    % número de precedencias de cada actividad
end

tic

% Llama a la funcion con el Metodo constructivo
soluciones=zeros(1,nt);
soluciones=MetodoConstructivo(Prec, -duraciones(:,2), nt);

%Llama a la función objetivo
soluciones(1,nt+1)=0;
[soluciones inicio]=makespan(soluciones, Prec, nprec, duraciones, rec, predecesor, cantidadRecursos, nrec, nt);

fin=0;
while fin==0
    fin=1;
    [mejorVecino mejorInicio]=InsercionAdelante(soluciones, inicio, Prec, nt, nprec, duraciones, rec, predecesor, cantidadRecursos, nrec);
    if mejorVecino(end)<soluciones(end)
        fin=0;
        soluciones=mejorVecino;
    end
end
        
toc
end

