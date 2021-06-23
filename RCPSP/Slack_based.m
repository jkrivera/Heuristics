function soluciones=Slack_based

duracion=['datos30\dura6666.txt']; %Duracion de cada actividad (Act. - Dur.)
recursos=['datos30\core6666.txt']; %Consumo de recursos por actividad (Rec. - Act. - Cons.)
predecesores=['datos30\pred6666.txt']; %Restricciones de precedencia de actividades (Act. antes - Act. Desp.)
cantidadRecursos=['datos30\recu6666.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
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

% Llama a la funcion con el Metodo constructivo
soluciones=zeros(1,nt);
soluciones=SlackMethod(Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));

error=validacion(soluciones, Prec, duraciones(:,2), nprec, nrec, rec, nt, cantidadRecursos(:,2));

%lb=CPM(Prec, duraciones(:,2), nt);

end

