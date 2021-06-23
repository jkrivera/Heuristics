function [best,prom]=main_Slack

duracion=['datos30\dura138.txt']; %Duracion de cada actividad (Act. - Dur.)
recursos=['datos30\core138.txt']; %Consumo de recursos por actividad (Rec. - Act. - Cons.)
predecesores=['datos30\pred138.txt']; %Restricciones de precedencia de actividades (Act. antes - Act. Desp.)
cantidadRecursos=['datos30\recu138.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
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
nsuc=zeros(1,nt);
for i=1:nt
    nprec(i)=sum(Prec(:,i));%es un vector con nt componentes que indica el
    % número de precedencias de cada actividad
    nsuc(i)=sum(Prec(i,:));
end

best=ones(1,6)*Inf;
prom=zeros(1,6);
nsim=10000;

%% Metodo constructivo
soluciones=SlackMethod(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
error=validacion(soluciones, Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
best(1)=soluciones(nt+1);
prom(1)=best(1);

%% Construcción GRASP
for sim=1:nsim
    soluciones=GRASPxSlack_Method(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
    error=validacion(soluciones, Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
    if soluciones(nt+1)<best(2)
        best(2)=soluciones(nt+1);
    end
    prom(2)=prom(2)+soluciones(nt+1);
end

%% Construcción con Ruido
for sim=1:nsim
    Noise=[0; randi(3,[nt-2,1])-1; 0];
    soluciones=SlackMethod(Prec, duraciones(:,2)+Noise, nprec, nrec, rec, nt, cantidadRecursos(:,2));
    soluciones=makespan(soluciones, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt);
    error=validacion(soluciones, Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
    if soluciones(nt+1)<best(3)
        best(3)=soluciones(nt+1);
    end
    prom(3)=prom(3)+soluciones(nt+1);
end

%% Construcción con Ruido V2
Noise=zeros(nt,1);
for sim=1:nsim
    %Noise=zeros(nt,1);
    j=0;
    while j<3
        k=randi(30);
        j=j+1;
        if Noise(k+1)==0
            Noise(k+1)=randi(3);
        else
            Noise(k+1)=0;
        end
    end
    soluciones=SlackMethod(Prec, duraciones(:,2)+Noise, nprec, nrec, rec, nt, cantidadRecursos(:,2));
    soluciones=makespan(soluciones, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt);
    error=validacion(soluciones, Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
    if soluciones(nt+1)<best(4)
        best(4)=soluciones(nt+1);
    end
    prom(4)=prom(4)+soluciones(nt+1);
end

%% ACO
soluciones=SlackMethod(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));
Q=soluciones(nt+1)*1.5;
a=0.5;
b=2;
r=0.8;
m=10;
F=ones(nt,nt)*Q/soluciones(nt+1);
for sim=1:nsim/m
    dF=zeros(nt,nt);
    for k=1:m
        soluciones=AntSlack(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2),F,a,b);
        if soluciones(nt+1)<best(5)
            best(5)=soluciones(nt+1);
        end
        for i=1:nt
            for j=i+1:nt
                dF(soluciones(i),soluciones(j))=dF(soluciones(i),soluciones(j))+Q/soluciones(nt+1);
            end
        end
        prom(5)=prom(5)+soluciones(nt+1);
    end
    F=F*r+dF;
end

%% ACO V2
w=0.7;
m=10;
r=0.8;
F=ones(nt,nt);
for sim=1:nsim/m
    dF=zeros(nt,nt);
    for k=1:m
        soluciones=AntSlack2(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2),F,w);
        if soluciones(nt+1)<best(6)
            best(6)=soluciones(nt+1);
        end
        for i=1:nt
            for j=i+1:nt
                dF(soluciones(i),soluciones(j))=dF(soluciones(i),soluciones(j))+1/soluciones(nt+1);
            end
        end
        prom(6)=prom(6)+soluciones(nt+1);
    end
    F=F*r+dF;
    for i=1:nt
        F(:,i)=F(:,i)/max(F(:,i));
    end
end
prom(1)=prom(1)*nsim;
prom=prom/nsim;
end

